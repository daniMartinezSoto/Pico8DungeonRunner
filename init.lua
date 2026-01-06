function _init()

 -- AQUI SE DEBERA DECIR QUE PERSONAJE ELIGE EL JUGADOR
 -- Y SE CREA EL PERSONAJE ELEGIDO DANDOLE NOMBRE PLAYER
 -- player = crear_personaje("mage", 63, 100, 2, 3)
 -- player = crear_personaje("warrior", 63, 100, 4, 2)
 player = crear_personaje("elf", 56, 110, 2, 4)

coins = {}
potions = {}
enemies = {}
potions_mana = {}
monedas_voladoras = {} 
 
-- Añadir objetos que empiezan arriba (fuera de pantalla o en el borde)
-- add(coins, crear_moneda(20, -10))
-- add(coins, crear_moneda(25, -20))

-- add(potions, crear_pocion(40, -15))
-- add(potions, crear_pocion(80, -25))

-- add(enemies, crear_enemigo("fireball", 30, -5))
-- add(enemies, crear_enemigo("slime", 70, -15))
-- add(enemies, crear_enemigo("ghost", 100, -25))
-- add(enemies, crear_enemigo("orc", 80, -45))

-- add(enemies, crear_enemigo("thief", 40, -20))

-- add(potions_mana, crear_pocion_mana(60, -30))
-- add(potions_mana, crear_pocion_mana(90, -40))
 
 message="mazmorra loca!"
 paso_timer=0
end