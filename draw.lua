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
spr(10, 56, 120)


-- Mostrar advertencia de ladrón
if warning_timer > 0 then
  print(warning_msg, 15, 50, 10)  -- rojo, centrado arriba
end


-- Dibujar monedas voladoras
for mv in all(monedas_voladoras) do
 mv:draw()
end

end

