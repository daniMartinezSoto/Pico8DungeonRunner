function _init()

player = crear_personaje("personaje", 56, 128, 4, 4, "coinPower")

coins = {}
potions = {}
enemies = {}
potions_mana = {}
monedas_voladoras = {} 
balas = {}


 -- RESETEAR VIDA Y POWER

 power = 100   
 score = 0
paso_timer = 0
player_muerto = false
muerte_timer = 0
game_over = false
life = 100

--VARIABLES SISTEMA DE SPAWN
 spawn_timer = 0
 wave_timer = 0
 evento_cooldown = 0

--INTRO
 game_state = "menu"
 golpes_puerta = 0
 camera_y = 0

 puerta_rota = nil

 power_msg = ""
power_msg_timer = 0
power_ready_shown = false
 
 
menu_sound_played = false
end