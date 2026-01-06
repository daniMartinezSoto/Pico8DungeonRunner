

function _update()

-- Sistema de spawn escalonado
spawn_timer += 3

if spawn_timer == 30 then
 add(coins, crear_moneda(20, -10))
elseif spawn_timer == 60 then
 add(coins, crear_moneda(70, -10))
elseif spawn_timer == 90 then
 add(potions, crear_pocion(40, -15))
elseif spawn_timer == 120 then
 add(enemies, crear_enemigo("fireball", 30, -5))
elseif spawn_timer == 150 then
 add(enemies, crear_enemigo("slime", 70, -15))
elseif spawn_timer == 180 then
 add(potions_mana, crear_pocion_mana(60, -30))
elseif spawn_timer == 210 then
 add(enemies, crear_enemigo("ghost", 100, -25))
elseif spawn_timer == 240 then
 add(enemies, crear_enemigo("thief", 40, -20))
elseif spawn_timer == 270 then
 add(potions, crear_pocion(80, -25))
elseif spawn_timer == 300 then
 add(enemies, crear_enemigo("orc", 80, -45))
elseif spawn_timer == 330 then
 add(potions_mana, crear_pocion_mana(90, -40))
end
--Utilidades varias:

--Que la vida no suba de 100
if life > 100 then life = 100 end


-- Countdown del mensaje de advertencia
if warning_timer > 0 then
  warning_timer -= 1
end

-- Actualizar monedas voladoras
for mv in all(monedas_voladoras) do
 mv:update()
end

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