
-- TIPOS DE ENEMIGOS
enemy_types = {
  fireball = {
    sprite = 3,
    sprite_w = 1,  
    sprite_h = 1,  
    damage = 10,
    speed = 3,
    movimiento="rebote",
    width = 8,
    height = 8
  },
  
  slime = {
    sprite = 16,
    sprite_w = 1,  
    sprite_h = 1,  
    damage = 5,
    speed = 2,
    movimiento="zigzag",
    width = 8,
    height = 8
  },
  
  ghost = {
    sprite = 17,
    sprite_w = 1,  
    sprite_h = 1,  
    damage = 15,
    speed = 5,
    movimiento="circular",
    width = 8,
    height = 8
  },
    orc = {
    sprite = 20,     
    sprite_w = 2,    
    sprite_h = 2,    
    damage = 50,     --mucho damage
    speed = 0.8,     -- más lento porque es grande
    width = 16,      
    height = 16
  },
  
  eye = {
    sprite = 09,
    sprite_w = 1,  
    sprite_h = 1,  
    damage = 15,
    speed = 2,
    movimiento="perseguidor",
    width = 8,
    height = 8
  },
  thief = {
  sprite = 23,       -- sprite izquierdo
  sprite_w = 2,      -- 2 sprites de ancho (23 y 24)
  sprite_h = 1,      -- 1 sprite de alto
  damage = 0,        -- NO quita vida
  roba_puntos = 1,  -- roba 10 puntos
  speed = 2,
  movimiento = "perseguidor",
  width = 11,        -- hitbox: 8px (sprite 23) + 3px (parte del 24)
  height = 8
}
}

function crear_enemigo(tipo, x, y)
 local info = enemy_types[tipo]
 
 return {
  tipo = tipo,
  x = x,
  y = y,
  sprite = info.sprite,
  sprite_w = info.sprite_w,  
  sprite_h = info.sprite_h,  
  damage = info.damage,
  roba_puntos = info.roba_puntos,
  speed = info.speed,
  direccion_x = info.direccion_x or 1,
  movimiento = info.movimiento or "normal",
  width = info.width,
  height = info.height,
  warning_shown = false,
  
  update = function(self)
  
    -- ALERTA DE LADRÓN (solo cuando entra en pantalla)
    if self.tipo == "thief" and self.y >= 0 and not self.warning_shown then
      warning_msg = "a thief! watch your coins!"
      warning_timer = 60  -- 3 segundos
      self.warning_shown = true
      sfx(10)  -- sonido de alerta opcional
    end
    
      -- MOVIMIENTO SEGÚN TIPO
    if self.movimiento == "zigzag" then
      self.y += self.speed
      self.x += sin(self.y / 10) * 2
      
    elseif self.movimiento == "perseguidor" then
      self.y += self.speed
      
      -- Persecución rápida y fluida
      local diff_x = player.x - self.x
      self.x += diff_x * 0.15
      
    elseif self.movimiento == "diagonal" then
      self.y += self.speed
      self.x += self.speed
      
    elseif self.movimiento == "rebote" then
      self.y += self.speed
      self.x += self.direccion_x * 1.5
      if self.x < 8 or self.x > 112 then
        self.direccion_x = -self.direccion_x
      end
      
    elseif self.movimiento == "circular" then
      self.y += self.speed * 0.5
      self.angulo = (self.angulo or 0) + 0.05
      self.x += cos(self.angulo) * 2
      
    else
      self.y += self.speed
    end
    
    -- COLISIÓN CON JUGADOR
    if colision(player, self) then
      -- SI ES LADRÓN, roba puntos
      if self.tipo == "thief" then
        score -= (self.roba_puntos or 10)
        if score < 0 then score = 0 end

            -- GENERAR MONEDAS VOLADORAS (efecto visual)
    for i=1,5 do  -- 5 monedas
      add(monedas_voladoras, crear_moneda_voladora(player.x, player.y))
    end
        sfx(11)


      else
        -- ENEMIGOS NORMALES quitan vida
        life -= self.damage
        sfx(5)
      end
      
      del(enemies, self)
    end
  end,
  
  draw = function(self)
    spr(self.sprite, self.x, self.y, self.sprite_w, self.sprite_h)
  end
 }
end

--BARRA DE VIDA
-- tamaño de la barra
bar_x = 20
bar_y = 10
bar_w = 88
bar_h = 5
life = 100

-- BARRA DE POWER (más pequeña y debajo)
bar_power_x = 48
bar_power_y = 20    -- debajo de la vida (10 + 8 + 2 de margen)
bar_power_w = 60      -- más estrecha
bar_power_h = 5      -- más bajita
power = 0


--FUNCION GENERAL DE COLISIONES
function colision(obj1, obj2)
 return obj1.x < obj2.x + obj2.width and
        obj1.x + obj1.width > obj2.x and
        obj1.y < obj2.y + obj2.height and
        obj1.y + obj1.height > obj2.y
end

--FUNCION CREAR MONEDAS
function crear_moneda(x, y)
 return {
  x=x,
  y=y,
  width=8,
  height=8,
  recogida=false,
  
  update=function(self)
     self.y += 3  -- ← AÑADIR (caen hacia abajo)

   -- Detectar colisión con el jugador
   if not self.recogida and colision(player, self) then
    self.recogida=true
    sfx(4)
    score += 5
   end
  end,
  
  draw=function(self)
   if not self.recogida then
    spr(6, self.x, self.y)
   end
  end
 }
end

--FUNCION CREAR MONEDA VOLADORA (efecto visual)
function crear_moneda_voladora(x, y)
 return {
  x = x,
  y = y,
  vx = rnd(4) - 2,  -- velocidad X aleatoria (-2 a +2)
  vy = -3 - rnd(2), -- velocidad Y hacia arriba
  vida = 30,        -- dura 30 frames
  
  update = function(self)
   self.x += self.vx
   self.y += self.vy
   self.vy += 0.2    -- gravedad
   self.vida -= 1
   
   -- eliminar cuando expire
   if self.vida <= 0 then
    del(monedas_voladoras, self)
   end
  end,
  
  draw = function(self)
   spr(6, self.x, self.y)
  end
 }
end


--FUNCION CREAR POCIONES
function crear_pocion(x, y)
 return {
  x=x,
  y=y,
  width=8,
  height=8,
  recogida=false,
  
  update=function(self)
    self.y += 1
   if not self.recogida and colision(player, self) then
    self.recogida=true
    sfx(3)
    if life < 100 then
     life = min(100, life + 5)
    end
    score += 2
   end
  end,
  
  draw=function(self)
   if not self.recogida then
    spr(7, self.x, self.y)
   end
  end
 }
end


--FUNCION CREAR POCIONES DE MANA
function crear_pocion_mana(x, y)
 return {
  x=x,
  y=y,
  width=8,
  height=8,
  recogida=false,
  
  update=function(self)
   self.y += 1  -- cae hacia abajo
   
   if not self.recogida and colision(player, self) then
    self.recogida=true
    sfx(7)  -- sonido diferente para mana
    
    -- Aumenta power (máximo 100)
    if power < 100 then
     power = min(100, power + 25)  -- +20 de mana
    end
    
    score += 3  -- puntos por recogerla
   end
  end,
  
  draw=function(self)
   if not self.recogida then
    spr(8, self.x, self.y)
   end
  end
 }
end

-- FUNCIÓN PARA CREAR PERSONAJES (estilo profesora)
function crear_personaje(character, x, y, sprite, speed)
 return {
  character=character,
  x=x,
  y=y,
  sprite=sprite,
  speed=speed,
  width=8,
  height=8,
  
  update=function(self)
   if btn(➡️) then self.x+=self.speed end
   if btn(⬅️) then self.x-=self.speed end
  --  if btn(⬆️) then self.y-=self.speed end
  --  if btn(⬇️) then self.y+=self.speed end

  self.x = mid(10, self.x, 111)
  
  end,

  
  
  draw=function(self)
   spr(self.sprite, self.x, self.y)
    
  end
 }
end

