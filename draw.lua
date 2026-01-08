function _draw()
 cls()


 -- PANTALLA DE GAME OVER
 if game_over then
  -- Fondo oscuro
  rectfill(0, 0, 128, 128, 0)
  
  -- Texto
  print("game over", 40, 50, 8)
  print("score: "..score, 42, 60, 7)
  print("press ❎ to restart", 20, 75, 6)
  return  -- no dibuja nada más
 end



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

-----------------------------------------------------
--PINTADO DE LA BARRA DE VIDA-------------------------
-- 1️⃣ borde gris
rect(bar_x-1, bar_y-1, bar_x+bar_w+1, bar_y+bar_h+1, 6)

-- 2️⃣ fondo azul oscuro
rectfill(bar_x, bar_y, bar_x+bar_w, bar_y+bar_h, 1)

-- 3️⃣ barra roja de vida
local life_width = max(0, bar_w * life / 100)  -- nunca negativo
rectfill(bar_x, bar_y, bar_x + life_width, bar_y + bar_h, 8)
-----------------------------------------------------

--PINTADO DE LA BARRA DE POWER------------------------
-- 1️⃣ borde gris
rect(bar_power_x-1, bar_power_y-1, bar_power_x+bar_power_w+1, bar_power_y+bar_power_h+1, 6)

-- 2️⃣ fondo azul oscuro
rectfill(bar_power_x, bar_power_y, bar_power_x+bar_power_w, bar_power_y+bar_power_h, 1)

-- 3️⃣ barra azul de power
rectfill(bar_power_x, bar_power_y, bar_power_x + (bar_power_w * power / 100), bar_power_y + bar_power_h, 12)
-----------------------------------------------------

-- OPCIÓN 4: Con emoji/símbolo
print("★ "..score, 20, 21, 10)
-- Muestra: "★45"




 -- DIBUJAR BORDES CON SPRITE DE MURO
 -- Borde izquierdo (columna de muros)
 for y=0,120,8 do
  spr(1, 0, y)
 end
 
 -- Borde derecho (columna de muros)
 for y=0,120,8 do
  spr(1, 120, y)
 end

-- SUELO (fila inferior) - con hueco para sprite 10 en x=56
for x=8,112,8 do
 if x != 56 then  -- NO pintar en 56
  spr(1, x, 120)
 end
end

-- DESPUÉS pintar el sprite 10 en ese hueco
spr(16, 56, 120)


-- Mostrar advertencia de ladrón
if warning_timer > 0 then
  print(warning_msg, 15, 50, 10)  -- rojo, centrado arriba
end


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
  print(coins_lost_msg, 40, 65, 8)  -- rojo, debajo del otro mensaje
end

 player:draw()

 -- APLICAR SHAKE
 local shake_x = 0
 local shake_y = 0
 if shake_timer > 0 then
  shake_x = rnd(shake_amount * 2) - shake_amount
  shake_y = rnd(shake_amount * 2) - shake_amount
  camera(shake_x, shake_y)
 else
  camera(0, 0)  -- resetear cámara
 end

end

