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
  if btnp(❎) then  -- X → reiniciar partida (ir a puerta)
    sfx(22)
    _init()
    game_state = "intro"  -- va directo a la puerta
    game_over = false
  end
  
  if btnp(🅾️) then  -- Z → volver al menú
    _init()
    game_state = "menu"  -- va al menú
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

-- ========== MENÚ ==========
if game_state == "menu" then
  if not menu_sound_played then
    sfx(10)
    menu_sound_played = true
  end
  if btnp(❎) or btnp(🅾️) then
      sfx(-1)
    game_state = "intro"
    sfx(27)
    -- ELEGIR SPRITE ALEATORIO
    local sprites = {2, 4, 5}
    local sprite_random = sprites[flr(rnd(3)) + 1]
    
    -- CREAR JUGADOR CON SPRITE ALEATORIO
    player = crear_personaje("personaje", 56, 128, sprite_random, 4, "fullHeal")
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
    
  -- GENERAR PRIMERA OLEADA INMEDIATA
 generar_oleada()
  wave_timer = 0
--IMPORTANTE GENERAR AQUI UNA PRIMERA OLEADA AL ENTRAR
--------------------------------------------------
  end
  return
end

-- ========== JUEGO NORMAL ========== ← MOVER AQUÍ
-- Incrementar contadores de spawn ← AÑADIR AQUÍ
spawn_timer += 1
wave_timer += 1

-- Calcular dificultad según score
dificultad = 1.0 + (score / 300)

-- Verificar cooldown de eventos
if evento_cooldown > 0 then
  evento_cooldown -= 1
  return  -- NO generar oleadas durante cooldown
end

-- Verificar cooldown de eventos
if evento_cooldown > 0 then
  evento_cooldown -= 1
  return
end


-- GENERAR OLEADAS CON PATRONES (velocidad según dificultad)
if dificultad >= 2.0 then
  next_wave_interval = 110   -- nivel 3: más rápido
elseif dificultad >= 1.5 then
  next_wave_interval = 120  -- nivel 2: medio
else
  next_wave_interval = 140  -- nivel 1: normal
end

if wave_timer >= next_wave_interval then
  generar_oleada()
  wave_timer = 0
end
if wave_timer >= next_wave_interval then
  generar_oleada()
  wave_timer = 0
end

-- Reducir shake
if shake_timer > 0 then
  shake_timer -= 1
end

-- Calcular dificultad según score
dificultad = 1.0 + (score / 300)

-- EVENTO NIVEL 2 (dificultad >= 1.5)
if dificultad >= 1.5 and not nivel_2_mostrado then
  nivel_2_mostrado = true
  
  -- LIMPIAR PANTALLA
  for e in all(enemies) do
    del(enemies, e)
  end
  
  -- SPAWNAR BEHOLDER
  add(enemies, crear_enemigo("beholder", 60, -20))
  
  -- CAMBIAR MÚSICA
  music(-1)  -- detener música actual
  music(2)   -- nueva música nivel 2
  
  -- MENSAJE
  power_msg = "level 2!"
  power_msg_timer = 90
  sfx(24)
  
  -- PAUSAR OLEADAS 3 SEG

  wave_timer = 0
end


-- EVENTO NIVEL 3 (dificultad >= 2.0)
if dificultad >= 2.0 and not nivel_3_mostrado then
  nivel_3_mostrado = true
  
  -- LIMPIAR PANTALLA
  for e in all(enemies) do
    del(enemies, e)
  end
   add(potions, crear_pocion(12,-10))
    add(potions, crear_pocion(50,0))

  -- SPAWNAR 2 GNOMOS
  add(enemies, crear_enemigo("gnomo", 40, -10))
  add(enemies, crear_enemigo("gnomo", 80, -10))
  
  -- CAMBIAR MÚSICA
  music(-1)
  music(20)
  
  -- MENSAJE
  power_msg = "level 3!"
  power_msg_timer = 90
  sfx(24)
  
  -- SIN PAUSA (no poner evento_cooldown)
end



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
  -- ELEGIR PODER ALEATORIO
  local poderes = {"coinPower", "clearScreen", "fullHeal"}
  player.power = poderes[flr(rnd(3)) + 1]
  
  -- MOSTRAR MENSAJE SEGÚN PODER
  if player.power == "coinPower" then
    power_msg = "you got treasure spell!"
  elseif player.power == "clearScreen" then
    power_msg = "you got clear spell!"
  elseif player.power == "fullHeal" then
    power_msg = "you got healing spell!"
  end
  
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
    sfx(26)
  else

    if player.power == "coinPower" then
   
      power = 0
      power_ready_shown = false
      sfx(25)
      
      -- GENERAR LLUVIA DE MONEDAS
      for i = 1, 15 do
        add(coins, crear_moneda(random_x(), -10 - rnd(40)))
      end
      
      shake_timer = 10
      shake_amount = 1

    elseif player.power == "clearScreen" then
 
      power = 0
      power_ready_shown = false
      sfx(21)
      
      -- ELIMINAR TODOS LOS ENEMIGOS
      for e in all(enemies) do
        del(enemies, e)
      end
      
      shake_timer = 30
      shake_amount = 2
      
elseif player.power == "fullHeal" then

  power = 0
  power_ready_shown = false
  sfx(23)  -- sonido de poción
  
  -- CURAR VIDA COMPLETA
  life = 100
  
  shake_timer = 5
  shake_amount = 0.5
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