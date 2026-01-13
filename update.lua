function _update()

-- MUERTE DEL JUGADOR
if life <= 0 and not player_muerto then
  shake_timer = 2
  shake_amount = 1
  player_muerto = true
  muerte_timer = 80
  
  -- Efecto de jugador volando
  player.vx = rnd(4) - 2
  player.vy = -4
  sfx(1,0)
  sfx(9,1)
  music(-1)
end

-- GAME OVER (pantalla final)
if game_over then
  if btnp(❎) then
    sfx(22)
    _init()
    game_over = false
  end
  return
end

-- Animación de muerte
if player_muerto then
  player.x += player.vx
  player.y += player.vy
  player.vy += 0.2
  
  muerte_timer -= 1
  
  if muerte_timer <= 0 then
    game_over = true
  end
  
  return
end

-- ========== INTRO ==========
if game_state == "intro" then
  -- Reducir shake en intro
  if shake_timer > 0 then
    shake_timer -= 1
  end
  
  if btnp(❎) then
    golpes_puerta += 1
    sfx(8)
    shake_timer = 2
    shake_amount = 1
    
    -- Al 4to golpe, rompe la puerta
    if golpes_puerta >= 4 then
      game_state = "entrando"
      sfx(17)
      shake_timer = 15
      shake_amount = 3
      
      -- CREAR PUERTA VOLANDO
      puerta_rota = {
        x = 56,
        y = 120,
        vx = rnd(4) - 2,
        vy = -4,
        vida = 60
      }
    end
  end
  return
end

-- ========== ENTRANDO (animación) ==========
if game_state == "entrando" then
  -- Reducir shake en entrando
  if shake_timer > 0 then
    shake_timer -= 1
  end
  
  -- Animar puerta rota
  if puerta_rota then
    puerta_rota.x += puerta_rota.vx
    puerta_rota.y += puerta_rota.vy
    puerta_rota.vy += 0.2
    puerta_rota.vida -= 1
    
    if puerta_rota.vida <= 0 then
      puerta_rota = nil
    end
  end
  
  -- Mover jugador hacia arriba
  if player.y > 110 then
    player.y -= 1
    camera_y -= 1
  else
    game_state = "playing"
    music(0)
    poke(0x3144, 3)  -- bajar volumen global de música (0-7)

    camera_y = 0
    puerta_rota = nil
    
 -- Tipos básicos
-- add(enemies, crear_enemigo("skeleton", 50, -10))
-- add(enemies, crear_enemigo("slime", 30, -15))
-- add(enemies, crear_enemigo("ghost", 70, -20))
-- add(enemies, crear_enemigo("eye", 40, -10))

-- Tipos especiales (2x2 sprites)
add(enemies, crear_enemigo("orc", 60, -20))
-- add(enemies, crear_enemigo("beholder", 80, -20))

-- Tipos con habilidades
-- add(enemies, crear_enemigo("thief", 45, -10))
-- add(enemies, crear_enemigo("gnomo", 55, -10))
    -- CREAR POCIONES INICIALES
    add(potions_mana, crear_pocion_mana(70, -25))
    add(potions_mana, crear_pocion_mana(70, -25))
    add(potions_mana, crear_pocion_mana(70, -25))
    add(potions_mana, crear_pocion_mana(70, -25))
  end
  return
end

-- ========== JUEGO NORMAL ==========

-- Reducir shake
if shake_timer > 0 then
  shake_timer -= 1
end

-- Utilidades varias
if life > 100 then life = 100 end
if life < 0 then life = 0 end

-- Countdowns de mensajes
if warning_timer > 0 then
  warning_timer -= 1
end

if orc_warning_timer > 0 then
  orc_warning_timer -= 1
end

if coins_lost_timer > 0 then
  coins_lost_timer -= 1
end

if power_msg_timer > 0 then
  power_msg_timer -= 1
end

-- Detectar cuando power llega a 100
if power >= 100 and not power_ready_shown then
  power_msg = "your power is ready!"
  power_msg_timer = 90
  power_ready_shown = true
  sfx(24)
end

-- Resetear flag si baja de 100
if power < 100 then
  power_ready_shown = false
end

-- Activar habilidad con X
if btnp(❎) then
  if power < 100 then
    power_msg = "not enough power!"
    power_msg_timer = 60
    sfx(6)
  else

if player.power == "coinPower" then

    power_msg = "COINPOWER!"
    power_msg_timer = 60
    power = 0
    power_ready_shown = false
    sfx(23)
    shake_timer = 30
    shake_amount = 2

elseif player.power == "clearScreen" then
    power_msg = "CLEARSCREEN!"
    power_msg_timer = 60
    power = 0
    power_ready_shown = false
    sfx(23)
    shake_timer = 30
    shake_amount = 2
elseif player.power == "shield" then
    power_msg = "SHIELD!"
    power_msg_timer = 60
    power = 0
    power_ready_shown = false
    sfx(23)
    shake_timer = 30
    shake_amount = 2
end


  end
end

-- Actualizar monedas voladoras
for mv in all(monedas_voladoras) do
 mv:update()
end

-- Actualizar jugador
player:update()

-- Actualizar pociones
for p in all(potions) do
 p:update()
end

-- Actualizar pociones de mana
for pm in all(potions_mana) do
 pm:update()
end

-- Actualizar monedas
for c in all(coins) do
 c:update()
end

-- Actualizar enemigos
for e in all(enemies) do
 e:update()
end

-- Actualizar balas
for b in all(balas) do
 b:update()
end

-- Sonido de pasos
if btn(➡️) or btn(⬅️) then
  paso_timer += 1
  if paso_timer > 10 then
   sfx(2)
   paso_timer = 0
  end
else
  paso_timer = 0
end

end