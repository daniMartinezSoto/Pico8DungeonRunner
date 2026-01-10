function _init()

 -- AQUI SE DEBERA DECIR QUE PERSONAJE ELIGE EL JUGADOR
 -- Y SE CREA EL PERSONAJE ELEGIDO DANDOLE NOMBRE PLAYER
 -- player = crear_personaje("mage", 63, 100, 2, 3)
 -- player = crear_personaje("warrior", 63, 100, 4, 2)
 player = crear_personaje("elf", 56, 128, 5, 4, "coinPower")

coins = {}
potions = {}
enemies = {}
potions_mana = {}
monedas_voladoras = {} 
balas = {}


 -- RESETEAR VIDA Y POWER

 power = 0   
 score = 0   
paso_timer = 0
player_muerto = false
muerte_timer = 0
game_over = false
life = 100


spawn_timer = 0

--INTRO
 game_state = "intro"
 golpes_puerta = 0
 camera_y = 0

 puerta_rota = nil

 power_msg = ""
power_msg_timer = 0
power_ready_shown = false
 
 

end