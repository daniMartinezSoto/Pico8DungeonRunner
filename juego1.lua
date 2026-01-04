-- VARIABLES
local coins, player, score, potions, enemies
score=0

-- TIPOS DE ENEMIGOS
enemy_types = {
  goblin = {
    sprite = 3,
    damage = 10,
    speed = 1,
    width = 8,
    height = 8
  },
  
  slime = {
    sprite = 16,
    damage = 5,
    speed = 2,
    width = 8,
    height = 8
  },
  
  ghost = {
    sprite = 17,
    damage = 15,
    speed = 1.5,
    width = 8,
    height = 8
  }
}

function crear_enemigo(tipo, x, y)
 local info = enemy_types[tipo]  -- busca la info del tipo
 
 return {
  tipo = tipo,
  x = x,
  y = y,
  sprite = info.sprite,
  damage = info.damage,
  speed = info.speed,
  width = info.width,
  height = info.height,
  
  update = function(self)
   -- Mover hacia abajo
   self.y += self.speed
   
   -- Detectar colisión con jugador
   if colision(player, self) then
    life -= self.damage  -- quita vida
    sfx(5)  -- sonido de daño
    del(enemies, self)  -- elimina el enemigo
   end
  end,
  
  draw = function(self)
   spr(self.sprite, self.x, self.y)
  end
 }
end

--BARRA DE VIDA
-- tamaño de la barra
bar_x = 20
bar_y = 10
bar_w = 88
bar_h = 8

-- vida actual (0 a 100)
life = 100


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
 
 -- Añadir algunas monedas y pociones de prueba
 add(coins, crear_moneda(20, 110))
 add(coins, crear_moneda(25, 110))
add(potions, crear_pocion(40, 110))
add(potions, crear_pocion(80, 110))

 add(enemies, crear_enemigo("goblin", 30, 0))
 add(enemies, crear_enemigo("slime", 70, 20))
 add(enemies, crear_enemigo("ghost", 100, 40))


 
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
 
 --PINTADO DE LA BARRA DE VIDA-------------------------
 -- 1️⃣ borde gris
 rect(bar_x-1, bar_y-1, bar_x+bar_w+1, bar_y+bar_h+1, 6)

 -- 2️⃣ fondo azul oscuro
 rectfill(bar_x, bar_y, bar_x+bar_w, bar_y+bar_h, 1)

 -- 3️⃣ barra roja de vida
 -- el ancho depende de life
 rectfill(bar_x, bar_y, bar_x + (bar_w * life / 100), bar_y + bar_h, 8)
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

 spr(3,64,63)
print("POINTS: "..score, 40, 22 , 7)


-- Dibujar todos los enemigos
for e in all(enemies) do
 e:draw()
end
end

