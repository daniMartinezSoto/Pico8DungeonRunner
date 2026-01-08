

function _update()

-- MUERTE DEL JUGADOR
if life <= 0 and not player_muerto then
  player_muerto = true
  muerte_timer = 80

  
  -- Efecto de jugador volando
  player.vx = rnd(4) - 2
  player.vy = -4
  sfx(1,0)
  sfx(9,1)
end

-- GAME OVER (pantalla final)
if game_over then
  if btnp(❎) then
    _init()
    game_over = false  -- ← IMPORTANTE: resetear aquí también
  end
  return  -- NO ejecutar nada más
end

-- Animación de muerte
if player_muerto then
  -- El jugador "vuela"

  player.x += player.vx
  player.y += player.vy
  player.vy += 0.2
  
  -- Countdown
  muerte_timer -= 1
  
  -- Después de la animación → Game Over
  if muerte_timer <= 0 then
    game_over = true
  end
  
  return  -- NO actualizar enemigos/balas durante muerte
end
-- resto del código normal...

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

if spawn_timer == 2 then
 add(enemies, crear_enemigo("skeleton", 50, -10))
end

if spawn_timer == 2 then
 add(enemies, crear_enemigo("slime", 10, -10))
end

if spawn_timer == 2 then
 add(enemies, crear_enemigo("gnomo", 60, -10))
end

if spawn_timer == 2 then
 add(enemies, crear_enemigo("beholder", 10, -10))
end

-- if spawn_timer == 180 then
--  add(potions_mana, crear_pocion_mana(60, -10))
-- end

-- if spawn_timer == 2 then
--  add(enemies, crear_enemigo("ghost", 50, -10))
-- end

-- if spawn_timer == 100 then
--  add(enemies, crear_enemigo("thief", 40, -10))
-- end

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

--Que la vida no suba de 100 y no baje de 0
if life > 100 then life = 100 end
if life < 0 then life = 0 end


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