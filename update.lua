

function _update()



-- Reducir shake
if shake_timer > 0 then
  shake_timer -= 1
end


--PRUEBA DE MOBS -------------------------------------------------------- 
--QUITAR MAS TARDE CUANDO SE CREE EL SISTEMA DE APARICION DE ENEMIGOS
-- Sistema de spawn escalonado
spawn_timer += 1

-- if spawn_timer == 30 then
--  add(coins, crear_moneda(20, -10))
-- end

-- if spawn_timer == 60 then
--  add(coins, crear_moneda(70, -10))
-- end

-- if spawn_timer == 90 then
--  add(potions, crear_pocion(40, -10))
-- end

-- if spawn_timer == 120 then
--  add(enemies, crear_enemigo("fireball", 50, -10))
-- end

-- if spawn_timer == 2 then
--  add(enemies, crear_enemigo("slime", 10, -10))
-- end

-- if spawn_timer == 2 then
--  add(enemies, crear_enemigo("gnomo", 60, -10))
-- end

if spawn_timer == 2 then
 add(enemies, crear_enemigo("beholder", 10, -10))
end

-- if spawn_timer == 180 then
--  add(potions_mana, crear_pocion_mana(60, -10))
-- end

-- if spawn_timer == 2 then
--  add(enemies, crear_enemigo("ghost", 50, -10))
-- end

if spawn_timer == 100 then
 add(enemies, crear_enemigo("thief", 40, -10))
end

-- if spawn_timer == 270 then
--  add(potions, crear_pocion(80, -10))
-- end

-- if spawn_timer == 10 then
--  add(enemies, crear_enemigo("orc", 80, -20))
-- end

-- if spawn_timer == 300 then
--  add(enemies, crear_enemigo("orc", 80, -20))
-- end
-- if spawn_timer == 330 then
--  add(potions_mana, crear_pocion_mana(90, -10))
-- end

---------------------------------------------------------------------------

--Utilidades varias:

--Que la vida no suba de 100
if life > 100 then life = 100 end


-- Countdown del mensaje de advertencia del ladron
if warning_timer > 0 then
  warning_timer -= 1
end

-- Countdown del mensaje del orco
if orc_warning_timer > 0 then
  orc_warning_timer -= 1
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

-- Countdown del mensaje de monedas perdidas por ladron
if coins_lost_timer > 0 then
  coins_lost_timer -= 1
end
 

-- Actualizar todos los enemigos
for e in all(enemies) do
 e:update()
end

-- Actualizar balas
for b in all(balas) do
 b:update()
end

 -- Sonido de pasos
 if btn(➡️) or btn(⬅️) then
  paso_timer+=1
  if paso_timer>10 then
   sfx(2)
   paso_timer=0
  end
 else
  paso_timer=0
 end
end