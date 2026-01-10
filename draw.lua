function _draw()
 cls()

 -- CALCULAR SHAKE (sin aplicar todavía)
 local shake_x = 0
 local shake_y = 0
 if shake_timer > 0 then
  shake_x = rnd(shake_amount * 2) - shake_amount
  shake_y = rnd(shake_amount * 2) - shake_amount
 end
 
 camera(shake_x, camera_y + shake_y)  -- ← COMBINAR AMBOS



 -- ========== GAME OVER ==========
 if game_over then
  camera(0, 0)  -- resetear cámara para game over
  rectfill(0, 0, 128, 128, 0)
  print("game over", 40, 50, 8)
  print("score: "..score, 42, 60, 7)
  print("press ❎ to restart", 20, 75, 6)
  return
 end

-- ========== INTRO / ENTRANDO ==========
if game_state == "intro" or game_state == "entrando" then
  camera(shake_x, 8 + shake_y)  -- ← COMBINADO!
  
  -- Dibujar suelo de mazmorra (TODO menos la fila del suelo)
  for y=0,112,8 do  -- hasta 112 (antes de la fila del suelo)
   for x=8,112,8 do
    spr(22, x, y)
   end
  end
  
  -- SUELO INFERIOR (y=120) con sprite 29
  for x=8,112,8 do
   spr(29, x, 128)  -- sprite 29 en toda la fila inferior
  end
  
  -- Muros laterales
  for y=0,140,8 do
   spr(1, 0, y)
   spr(1, 120, y)
  end
  
  -- Muros del suelo (encima del sprite 29)
  for x=8,112,8 do
   if x != 56 then
    spr(1, x, 120)
   end
  end
  
-- Puerta (solo si NO está rota)
if golpes_puerta < 4 then
  spr(13, 56, 120)
elseif not puerta_rota then
  spr(10, 56, 120)  -- puerta abierta (si ya no vuela)
end

-- Dibujar puerta volando
if puerta_rota then
  spr(14, puerta_rota.x, puerta_rota.y)
end
  
  -- Jugador
  player:draw()
  
  -- Texto
  if game_state == "intro" then
    camera(0, 0)
    print("break the door", 30, 30, 7)
    print("to enter the dungeon", 18, 40, 6)
    print("press ❎", 45, 60, 10)
  end
  
  camera(0, 0)
  return
end

 -- ========== JUEGO NORMAL (solo si game_state == "playing") ==========

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

 -- Dibujar todas las pociones
 for p in all(potions) do
  p:draw()
 end

 -- Dibujar todas las monedas
 for c in all(coins) do
  c:draw()
 end

 -- Dibujar pociones de mana
 for pm in all(potions_mana) do
  pm:draw()
 end

 --PINTADO DE LA BARRA DE VIDA-------------------------
 rect(bar_x-1, bar_y-1, bar_x+bar_w+1, bar_y+bar_h+1, 6)
 rectfill(bar_x, bar_y, bar_x+bar_w, bar_y+bar_h, 1)
 local life_width = max(0, bar_w * life / 100)
 rectfill(bar_x, bar_y, bar_x + life_width, bar_y + bar_h, 8)

 --PINTADO DE LA BARRA DE POWER------------------------
 rect(bar_power_x-1, bar_power_y-1, bar_power_x+bar_power_w+1, bar_power_y+bar_power_h+1, 6)
 rectfill(bar_power_x, bar_power_y, bar_power_x+bar_power_w, bar_power_y+bar_power_h, 1)
 local power_width = max(0, bar_power_w * power / 100)
 rectfill(bar_power_x, bar_power_y, bar_power_x + power_width, bar_power_y + bar_power_h, 12)

 -- Score
 print("★ "..score, 20, 21, 10)

 -- Dibujar jugador
 player:draw()

 -- DIBUJAR BORDES CON SPRITE DE MURO
 for y=0,120,8 do
  spr(1, 0, y)  -- izquierdo
  spr(1, 120, y)  -- derecho
 end

 -- SUELO (fila inferior) - con hueco para sprite 10 en x=56
 for x=8,112,8 do
  if x != 56 then
   spr(1, x, 120)
  end
 end

 -- Puerta en el suelo (durante el juego)
 spr(10, 56, 120)

 -- Dibujar monedas voladoras
 for mv in all(monedas_voladoras) do
  mv:draw()
 end

 -- Dibujar balas
 for b in all(balas) do
  b:draw()
 end

 -- Mostrar advertencia del orco
 if orc_warning_timer > 0 then
  print(orc_warning_msg, 10, 60, 10)
 end

 -- Mostrar advertencia de ladrón
 if warning_timer > 0 then
  print(warning_msg, 15, 50, 10)
 end

 -- Mostrar monedas perdidas
 if coins_lost_timer > 0 then
  print(coins_lost_msg, 40, 65, 8)
 end

-- Mostrar mensaje de power
if power_msg_timer > 0 then
  print(power_msg, 25, 75, 10)
end
end

