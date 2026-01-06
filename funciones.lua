


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
  speed = info.speed,
  direccion_x = info.direccion_x or 1,
  movimiento = info.movimiento or "normal",
  width = info.width,
  height = info.height,
  warning_shown = false,
  
  update = function(self)
  
    -- ALERTA DE LADRÓN (solo cuando entra en pantalla)
    if self.tipo == "thief" and self.y >=-40 and not self.warning_shown then
      warning_msg = "a thief! watch your coins!"
      warning_timer = 60  -- 3 segundos
      self.warning_shown = true
      sfx(10)  -- sonido de alerta opcional
    end

-- ALERTA DE ORCO (solo la PRIMERA vez que aparece uno)
if self.tipo == "orc" and self.y >= -30 and not self.warning_shown and not orc_warning_shown_once then
  orc_warning_msg = "don't get close to the orc!"
  orc_warning_timer = 90
  self.warning_shown = true
  orc_warning_shown_once = true  -- ← marca que ya se mostró
  sfx(12)
end
    
      -- MOVIMIENTO SEGÚN TIPO
if self.movimiento == "zigzag" then
  self.y += self.speed
  self.x += sin(self.y / 40) * 6  -- /40 = MÁS LENTO, *6 = MÁS AMPLIO
      
    elseif self.movimiento == "perseguidor" then
      self.y += self.speed
      
      -- Persecución rápida y fluida
      local diff_x = player.x - self.x
      self.x += diff_x * 0.15
      
elseif self.movimiento == "orco" then
  -- Inicializar fase
  self.fase = (self.fase or "lento")
  
  if self.fase == "lento" then
    -- Solo baja lento, SIN perseguir
    self.y += self.speed * 0.5
    
    -- Solo embiste si está dentro de la pantalla y cerca del jugador
    local distancia_y = player.y - self.y
    if self.y > 20 and distancia_y > 0 and distancia_y < 100 and abs(self.x - player.x) < 25 then
      self.fase = "rapido"
      sfx(13)
    end
    
  else
    -- fase rápida (embestida) - solo baja rápido, NO persigue
    self.y += self.speed * 3
  end

      
elseif self.movimiento == "rebote" then
  self.y += self.speed * 0.6  -- baja MÁS (era 0.3)
  self.x += self.direccion_x * 2.5  -- menos horizontal (era 3)
  if self.x < 8 or self.x > 112 then
    self.direccion_x = -self.direccion_x
  end

      
    elseif self.movimiento == "circular" then
 -- Inicializar variables si no existen
  self.angulo_percent = (self.angulo_percent or 0)
  self.centro_x = (self.centro_x or 60)  -- centro horizontal fijo
  self.centro_y = (self.centro_y or self.y)
  
  -- Incrementar ángulo (0 a 1 = círculo completo)
  self.angulo_percent += 0.02  -- velocidad de rotación
  if self.angulo_percent > 1 then 
    self.angulo_percent = 0 
  end
  
  -- El centro baja lentamente
  self.centro_y += self.speed * 0.2
  
  -- Calcular posición en el círculo
  local radio = 20  -- tamaño del círculo
  self.x = self.centro_x + radio * cos(self.angulo_percent)
  self.y = self.centro_y + radio * sin(self.angulo_percent)
      
    else
      self.y += self.speed
    end
    
    -- COLISIÓN CON JUGADOR
    if colision(player, self) then
      -- SI ES LADRÓN, roba puntos
if self.tipo == "thief" then
  local coins_stolen = flr(rnd(10)) + 1
  score -= coins_stolen
  if score < 0 then score = 0 end

-- ACTIVAR SHAKE
shake_timer = 2  -- dura 10 frames
shake_amount = 0.1  -- intensidad del temblor

  -- MENSAJE de monedas perdidas
  coins_lost_msg =coins_stolen .. " coins stolen!"
  coins_lost_timer = 60  -- dura 2 segundos

  -- GENERAR MONEDAS VOLADORAS
  for i = 1, coins_stolen do
    add(monedas_voladoras, crear_moneda_voladora(player.x, player.y))
  end
  sfx(11)

      else
        
        -- ENEMIGOS NORMALES quitan vida
        life -= self.damage
        sfx(5)
      end
      
    --screenShake del orco
    if self.tipo == "orc" then
      shake_timer = 15
      shake_amount = 4
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

