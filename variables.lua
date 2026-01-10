-- VARIABLES
local coins, player, score, potions, enemies, potions_mana, monedas_voladoras, dificultad, balas
score=0
dificultad=1;

warning_msg = "a thief! watch your coins!"
warning_timer = 0

local game_over = false


local orc_warning_msg = ""
local orc_warning_timer = 0
local orc_warning_shown_once = false

local spawn_timer = 0

local coins_lost_msg = ""
local coins_lost_timer = 0

local shake_timer = 0
local shake_amount = 0

local muerte_timer = 0
local player_muerto = false


--VARIABLES INTRO

local game_state = "intro"
local golpes_puerta = 0
local camera_y = 0

local puerta_rota = nil  -- para la animación de la puerta volando


-- Sistema de habilidades
local power_msg = ""
local power_msg_timer = 0
local power_ready_shown = false  -- para mostrar "ready" solo una vez


-- TIPOS DE ENEMIGOS
enemy_types = {
  skeleton = {
    sprite = 32,
    sprite_w = 1,  
    sprite_h = 1,  
    damage = 10,
    speed = 1.2,
    movimiento="rebote",
    width = 5,
    height = 5
  },
  
  slime = {
    sprite = 16,
    sprite_w = 1,  
    sprite_h = 1,  
    damage = flr(rnd(11)) + 15, --daño entre 15 y 25
    speed = 1,
    movimiento="zigzag",
    width = 8,
    height = 8
  },
  
  ghost = {
    sprite = 17,
    sprite_w = 1,  
    sprite_h = 1,  
    damage = 15,
    speed = 5,
    movimiento="circular",
    width = 8,
    height = 8
  },
    orc = {
    sprite = 20,     
    sprite_w = 2,    
    sprite_h = 2,    
    damage = 50,     --mucho damage
    speed = 1.2,
    movimiento="orco",
    width = 16,      
    height = 16
  },
  
  eye = {
    sprite = 09,
    sprite_w = 1,  
    sprite_h = 1,  
    damage = 15,
    speed = 2,
    movimiento="perseguidor",
    width = 8,
    height = 8
  },
  thief = {
  sprite = 23,       -- sprite izquierdo
  sprite_w = 2,      -- 2 sprites de ancho (23 y 24)
  sprite_h = 1,      -- 1 sprite de alto
  damage = 0,        -- NO quita vida
  speed = 1.3,
  movimiento = "perseguidor",
  width = 6,        --11 hitbox: 8px (sprite 23) + 3px (parte del 24)
  height = 6
}, 
  beholder = {
    sprite = 11,     
    sprite_w = 2,    
    sprite_h = 2,    
    damage = 40,     
    speed = 0.8,
    movimiento="escalera",
    width = 16,      
    height = 16
  },
  
  gnomo = {
  sprite = 25,
  sprite_w = 1,
  sprite_h = 1,
  damage = 8,
  speed = 0.3,
  movimiento = "tirador_normal",
  width = 8,
  height = 8
}
}
