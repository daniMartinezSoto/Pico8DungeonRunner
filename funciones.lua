


function crear_enemigo(tipo, x, y)
 local info = enemy_types[tipo]
 
 return {
  tipo = tipo,
  x = x,
  y = y,
  sprite = info.sprite,
  sprite_w = info.sprite_w,  
  sprite_h = info.sprite_h,  
  damage = info.damage*dificultad,
  speed = info.speed * dificultad,
  direccion_x = info.direccion_x or 1,
  movimiento = info.movimiento or "normal",
  width = info.width,
  height = info.height,
  warning_shown = false,
  
  update = function(self)

    --SISTEMA DE BORRADO DE PERSONAJES SI SALEN POR ABAJO
     if self.y > 135 then
    del(enemies, self)
  end
  
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
  self.x += sin(self.y / 30) * 2 -- /40 = MÁS LENTO, *6 = MÁS AMPLIO
      
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
if self.y > 20 and distancia_y > 0 and distancia_y < 100 and abs(self.x - player.x) < 8 then  -- <-- 8 píxeles
      self.fase = "rapido"
      sfx(13)
    end
    
  else
    -- fase rápida (embestida) - solo baja rápido, NO persigue
    self.y += self.speed * 6
  end

      
elseif self.movimiento == "rebote" then
  self.y += self.speed * 0.6  -- baja MÁS (era 0.3)
  self.x += self.direccion_x * 2.5  -- menos horizontal (era 3)
  if self.x < 8 or self.x > 112 then
    sfx(16)
    self.direccion_x = -self.direccion_x
  end

    elseif self.movimiento == "escalera" then
  self.fase_escalera = (self.fase_escalera or "horizontal")
  self.timer_escalera = (self.timer_escalera or 0)
  self.direccion_h = (self.direccion_h or 1)
  self.disparo_timer = (self.disparo_timer or 0)  -- ← AÑADIR
  
  self.timer_escalera += 1
  self.disparo_timer += 1  -- ← AÑADIR
  
  if self.fase_escalera == "horizontal" then
    -- Mueve horizontalmente
    self.x += self.direccion_h * 2
    
    -- DISPARAR mientras se mueve horizontal
    if self.disparo_timer > 40 then
      add(balas, crear_bala(self.x + 4, self.y + 8, 3, "normal"))
      sfx(14)
      self.disparo_timer = 0
    end
    
    -- Cambiar a bajar después de X frames o si toca borde
    if self.timer_escalera > 30 or self.x < 10 or self.x > 110 then
      self.fase_escalera = "bajar"
      self.timer_escalera = 0
      if self.x < 10 then self.direccion_h = 1 end
      if self.x > 110 then self.direccion_h = -1 end
    end
    
  else  -- fase bajar
    self.y += self.speed
    
    -- Cambiar a horizontal después de bajar un poco
    if self.timer_escalera > 20 then
      self.fase_escalera = "horizontal"
      self.timer_escalera = 0
    end
  end

elseif self.movimiento == "tirador_normal" then
  -- Baja recto
  self.y += self.speed
  
  -- Movimiento lateral aleatorio una sola vez a los 3 segundos
  self.lateral_timer = (self.lateral_timer or 0) + 1
  if self.lateral_timer > 90 and not self.se_movio then  -- 90 frames ≈ 3 segundos
    self.direccion_lateral = (rnd(1) < 0.5) and -1 or 1  -- -1 izq, 1 der
    self.se_movio = true
  end
  
  -- Aplicar movimiento lateral si ya se activó
if self.se_movio then
  self.x += self.direccion_lateral * 1.5
  
  -- Rebotar en las murallas (asumiendo muralla en x=8 y x=120)
  if self.x < 8 then
    self.x = 8
    self.direccion_lateral = 1  -- cambia a derecha
  elseif self.x > 112 then  -- 120-8 (ancho del sprite)
    self.x = 112
    self.direccion_lateral = -1  -- cambia a izquierda
  end
end
  
  -- Disparar bala perseguidora cada X frames
  self.disparo_timer = (self.disparo_timer or 0) + 1
  if self.disparo_timer > 50 then
    -- Disparar 5 balas en abanico fijo
    add(balas, crear_bala(self.x + 4, self.y + 8, 6, "prueba", -1))
    add(balas, crear_bala(self.x + 4, self.y + 8, 6, "prueba", -0.5))
    add(balas, crear_bala(self.x + 4, self.y + 8, 6, "prueba", 0))
    add(balas, crear_bala(self.x + 4, self.y + 8, 6, "prueba", 0.5))
    add(balas, crear_bala(self.x + 4, self.y + 8, 6, "prueba", 1))
    
    sfx(15)
    self.disparo_timer = 0
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
        
        -- ENEMIGOS NORMALES quitan vida y shake
        life -= self.damage
        shake_timer = 1  -- dura 10 frames
        shake_amount = 0.1  -- intensidad del temblor
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

-- FUNCIÓN PARA CREAR PERSONAJES (estilo)
function crear_personaje(character, x, y, sprite, speed, power)
 return {
  character=character,
  x=x,
  y=y,
  sprite=sprite,
  speed=speed,
  width=8,
  height=8,
  power=power,
  
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

--FUNCION CREAR BALA 
function crear_bala(x, y, velocidad, tipo, direccion)  -- <-- añadir direccion aquí
 -- Tipos de bala con sus propiedades
 local bala_tipos = {
  normal = {sprite = 3, damage = 30*dificultad, width = 3, height = 4},
  prueba = {sprite = 26, damage = 10*dificultad, width = 5, height = 6}
 }
 
 local info = bala_tipos[tipo] or bala_tipos.normal
 
 return {
  x = x,
  y = y,
  vel_y = velocidad,
  tipo = tipo,
  sprite = info.sprite,
  damage = info.damage,
  width = info.width,
  height = info.height,
  direccion_x = direccion,  -- <-- guardar la dirección recibida
  
  update = function(self)
   -- MOVIMIENTO según tipo
   if self.tipo == "prueba" then
     -- Usar la dirección que ya tenemos guardada
     self.y += self.vel_y           -- baja
     self.x += self.direccion_x * 2  -- se mueve en diagonal
   else
     -- Normal: solo baja recto
     self.y += self.vel_y
   end
   
   -- Colisión con jugador
   if colision(player, self) then
    life -= self.damage
    sfx(5)
    del(balas, self)
   end
   
   -- Eliminar si sale de pantalla
   if self.y > 128 then
    del(balas, self)
   end
  end,
  
  draw = function(self)
   if self.sprite then
    spr(self.sprite, self.x, self.y)
   else
    rectfill(self.x, self.y, self.x+self.width, self.y+self.height, 8)
   end
  end
 }
end