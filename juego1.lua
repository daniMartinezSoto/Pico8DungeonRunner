-- VARIABLES
local coins, player, score, potions, enemies, potions_mana
score=0

-- TIPOS DE ENEMIGOS
enemy_types = {
  goblin = {
    sprite = 3,
    sprite_w = 1,  
    sprite_h = 1,  
    damage = 10,
    speed = 1,
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
  speed = info.speed,
  direccion_x = info.direccion_x or 1,
  movimiento = info.movimiento or "normal",
  width = info.width,
  height = info.height,
  
  
update = function(self)
  -- MOVIMIENTO SEGÚN TIPO
  
  if self.movimiento == "zigzag" then
    self.y += self.speed
    self.x += sin(self.y / 10) * 2  -- onda suave de lado a lado
    
  elseif self.movimiento == "perseguidor" then
    self.y += self.speed
    -- se mueve hacia el jugador horizontalmente
    if self.x < player.x then
      self.x += 0.5
    elseif self.x > player.x then
      self.x -= 0.5
    end
    
  elseif self.movimiento == "diagonal" then
    self.y += self.speed
    self.x += self.speed  -- baja en diagonal
    
  elseif self.movimiento == "rebote" then
    self.y += self.speed
    self.x += self.direccion_x * 1.5  -- se mueve en X
    -- rebota en los bordes
    if self.x < 8 or self.x > 112 then
      self.direccion_x = -self.direccion_x
    end
    
  elseif self.movimiento == "circular" then
    self.y += self.speed * 0.5
    self.angulo = (self.angulo or 0) + 0.05
    self.x += cos(self.angulo) * 2  -- movimiento circular
    
  else
    self.y += self.speed  -- normal (hacia abajo)
  end
  
   
   if colision(player, self) then
    life -= self.damage
    sfx(5)
    del(enemies, self)
   end
  end,
  
  draw = function(self)
   spr(self.sprite, self.x, self.y, self.sprite_w, self.sprite_h)  -- ← CAMBIAR
  end
 }
end

--BARRA DE VIDA
-- tamaño de la barra
bar_x = 20
bar_y = 10
bar_w = 88
bar_h = 8
life = 100

-- BARRA DE POWER (más pequeña y debajo)
bar_power_x = 35
bar_power_y = 25     -- debajo de la vida (10 + 8 + 2 de margen)
bar_power_w = 60      -- más estrecha
bar_power_h = 6       -- más bajita
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
    sfx(6)  -- sonido diferente para mana
    
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

function _init()

 -- AQUI SE DEBERA DECIR QUE PERSONAJE ELIGE EL JUGADOR
 -- Y SE CREA EL PERSONAJE ELEGIDO DANDOLE NOMBRE PLAYER
 -- player = crear_personaje("mage", 63, 100, 2, 3)
 -- player = crear_personaje("warrior", 63, 100, 4, 2)
 player = crear_personaje("elf", 63, 110, 2, 2)

coins = {}
potions = {}
enemies = {}
potions_mana = {}
 
 -- Añadir algunas monedas y pociones de prueba
 add(coins, crear_moneda(20, 10))
 add(coins, crear_moneda(25, 10))
add(potions, crear_pocion(40, 10))
add(potions, crear_pocion(80, 10))

 add(enemies, crear_enemigo("goblin", 30, 0))
 add(enemies, crear_enemigo("slime", 70, 20))
 add(enemies, crear_enemigo("ghost", 100, 40))

 add(enemies, crear_enemigo("orc", 50, 0))

add(potions_mana, crear_pocion_mana(60, 10))
add(potions_mana, crear_pocion_mana(90, 30))
 
 message="mazmorra loca!"
 paso_timer=0
end

function _update()

--Utilidades varias:

--Que la vida no suba de 100
if life > 100 then life = 100 end


--------------------------------------------------------

 -- Actualizar jugador, objetos y monstruos etc..
 player:update()

-- Actualizar todas las pociones
for p in all(potions) do
 p:update()
end

-- Actualizar pociones de mana
for pm in all(potions_mana) do
 pm:update()
end


 -- Actualizar todas las monedas
for c in all(coins) do
 c:update()
end
 

-- Actualizar todos los enemigos
for e in all(enemies) do
 e:update()
end

 -- Sonido de pasos
 if btn(➡️) or btn(⬅️) or btn(⬆️) or btn(⬇️) then
  paso_timer+=1
  if paso_timer>10 then
   sfx(2)
   paso_timer=0
  end
 else
  paso_timer=0
 end
end

function _draw()
 cls()

 -- RELLENAR SUELO DE LA MAZMORRA (todo el fondo)
 for y=0,120,8 do
  for x=8,112,8 do
   spr(22, x, y)
  end
 end

 -- Dibujar todos los enemigos
for e in all(enemies) do
 e:draw()
end
 
 --PINTADO DE LA BARRA DE VIDA-------------------------
 -- 1️⃣ borde gris
 rect(bar_x-1, bar_y-1, bar_x+bar_w+1, bar_y+bar_h+1, 6)

 -- 2️⃣ fondo azul oscuro
 rectfill(bar_x, bar_y, bar_x+bar_w, bar_y+bar_h, 1)

 -- 3️⃣ barra roja de vida
 -- el ancho depende de life
 rectfill(bar_x, bar_y, bar_x + (bar_w * life / 100), bar_y + bar_h, 8)
-----------------------------------------------------
--PINTADO DE LA BARRA DE VIDA-------------------------
-- 1️⃣ borde gris
rect(bar_x-1, bar_y-1, bar_x+bar_w+1, bar_y+bar_h+1, 6)

-- 2️⃣ fondo azul oscuro
rectfill(bar_x, bar_y, bar_x+bar_w, bar_y+bar_h, 1)

-- 3️⃣ barra roja de vida
rectfill(bar_x, bar_y, bar_x + (bar_w * life / 100), bar_y + bar_h, 8)
-----------------------------------------------------

--PINTADO DE LA BARRA DE POWER------------------------
-- 1️⃣ borde gris
rect(bar_power_x-1, bar_power_y-1, bar_power_x+bar_power_w+1, bar_power_y+bar_power_h+1, 6)

-- 2️⃣ fondo azul oscuro
rectfill(bar_power_x, bar_power_y, bar_power_x+bar_power_w, bar_power_y+bar_power_h, 1)

-- 3️⃣ barra azul de power
rectfill(bar_power_x, bar_power_y, bar_power_x + (bar_power_w * power / 100), bar_power_y + bar_power_h, 12)
-----------------------------------------------------


 -- Dibujar todo
 player:draw()

-- Dibujar todas las pociones
for p in all(potions) do
 p:draw()
end

 
-- Dibujar todas las monedas
for c in all(coins) do
 c:draw()
end

-- OPCIÓN 4: Con emoji/símbolo
print("★ "..score, 14, 26, 10)
-- Muestra: "★45"


-- Dibujar pociones de mana
for pm in all(potions_mana) do
 pm:draw()
end



 -- DIBUJAR BORDES CON SPRITE DE MURO
 -- Borde izquierdo (columna de muros)
 for y=0,120,8 do
  spr(1, 0, y)
 end
 
 -- Borde derecho (columna de muros)
 for y=0,120,8 do
  spr(1, 120, y)
 end

  -- SUELO (fila inferior) ← AÑADIR ESTO
 for x=8,112,8 do
  spr(1, x, 120)
 end




end

