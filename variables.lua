-- VARIABLES
local coins, player, score, potions, enemies, potions_mana, monedas_voladoras, dificultad, balas
score=0
dificultad=1;

warning_msg = "a thief! watch your coins!"
warning_timer = 0

local game_over = false


local orc_warning_msg = "don't get close to the orc!"
local orc_warning_timer = 0
local orc_warning_shown_once = false


local coins_lost_msg = ""
local coins_lost_timer = 0

local shake_timer = 0
local shake_amount = 0

local muerte_timer = 0
local player_muerto = false


nivel_actual = 1
nivel_2_mostrado = false
nivel_3_mostrado = false

--VARIABLES INTRO

local game_state = "intro"
local golpes_puerta = 0
local camera_y = 0

local puerta_rota = nil  -- para la animación de la puerta volando

-- SISTEMA DE SPAWN
local spawn_timer = 0
local wave_timer = 0

local evento_cooldown = 0


-- Sistema de habilidades
local power_msg = ""
local power_msg_timer = 0
local power_ready_shown = false  -- para mostrar "ready" solo una vez
local player_power_assigned = false

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
    speed = 1,
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


-- PATRONES DE OLEADAS
-- PATRONES DE OLEADAS
-- PATRONES DE OLEADAS
wave_patterns = {
  -- ========== OLEADAS FÁCILES (60% total) ==========
  
  {
    peso = 5,
    nivel_min = 1,
    enemigos = {
      {tipo = "slime"},
      {tipo = "slime"},
      {tipo = "skeleton"}
    },
    monedas = 4,
    pocion_vida = true,
    pocion_mana = true
  },
  
  {
    peso = 5,
    nivel_min = 1,
    enemigos = {
      {tipo = "ghost"},
      {tipo = "ghost"},
      {tipo = "skeleton"}
    },
    monedas = 3,
    pocion_vida = true,
    pocion_mana = true
  },
  
  {
    peso = 5,
    nivel_min = 1,
    enemigos = {
      {tipo = "skeleton"},
      {tipo = "skeleton"},
      {tipo = "skeleton"}
    },
    monedas = 4,
    pocion_vida = true,
    pocion_mana = true
  },
  
  {
    peso = 5,
    nivel_min = 1,
    enemigos = {
      {tipo = "slime"},
      {tipo = "skeleton"}
    },
    monedas = 3,
    pocion_vida = false,
    pocion_mana = true
  },
  
  {
    peso = 5,
    nivel_min = 1,
    enemigos = {
      {tipo = "ghost"},
      {tipo = "ghost"},
      {tipo = "slime"}
    },
    monedas = 4,
    pocion_vida = true,
    pocion_mana = true
  },
  
  {
    peso = 5,
    nivel_min = 1,
    enemigos = {
      {tipo = "ghost"},
      {tipo = "skeleton"}
    },
    monedas = 3,
    pocion_vida = false,
    pocion_mana = true
  },
  {
    peso = 2,
    nivel_min = 1,
    enemigos = {
      {tipo = "thief"},
      {tipo = "skeleton"}
      
    },
    monedas = 3,
    pocion_vida = false,
    pocion_mana = true
  },


  
  -- ========== OLEADAS INTERMEDIAS (30% total) ==========
  
  {
    peso = 4,
    nivel_min = 1.5,
    enemigos = {
      {tipo = "thief"},
      {tipo = "slime"},
      {tipo = "ghost"}
    },
    monedas = 3,
    pocion_vida = false,
    pocion_mana = true
  },
  
  {
    peso = 4,
    nivel_min = 1.5,
    enemigos = {
      {tipo = "beholder"},
      {tipo = "slime"}
    },
    monedas = 3,
    pocion_vida = true,
    pocion_mana = true
  },
  
  {
    peso = 4,
    nivel_min = 1.5,
    enemigos = {
      {tipo = "gnomo"}
    },
    monedas = 3,
    pocion_vida = false,
    pocion_mana = true
  },
  
  -- ========== OLEADAS DIFÍCILES (9% total) ==========
  
  {
    peso = 2,
    nivel_min = 2.0,
    enemigos = {
      {tipo = "thief"},
      {tipo = "gnomo"}
    },
    monedas = 3,
    pocion_vida = true,
    pocion_mana = true
  },
  
  {
    peso = 2,
    nivel_min = 2.0,
    enemigos = {
      {tipo = "beholder"},
      {tipo = "beholder"}
    },
    monedas = 3,
    pocion_vida = false,
    pocion_mana = true
  },
  
  {
    peso = 1,
    nivel_min = 2.0,
    enemigos = {
      {tipo = "gnomo"},
      {tipo = "beholder"}
    },
    monedas = 3,
    pocion_vida = false,
    pocion_mana = true
  },
  
  {
    peso = 2,
    nivel_min = 2.0,
    enemigos = {
      {tipo = "slime"},
      {tipo = "orc"}
    },
    monedas = 3,
    pocion_vida = false,
    pocion_mana = true
  },
  
  {
    peso = 1,
    nivel_min = 2.0,
    enemigos = {
      {tipo = "slime"},
      {tipo = "orc"},
      {tipo = "ghost"}
    },
    monedas = 3,
    pocion_vida = true,
    pocion_mana = true
  },
  
  -- ========== EVENTOS ESPECIALES (1% total) ==========
  
  {
    peso = 0.5,
    nivel_min = 1,
    enemigos = {},
    monedas = 15,
    pocion_vida = false,
    pocion_mana = true
  },
  
  {
    peso = 0.5,
    nivel_min = 1,
    enemigos = {},
    monedas = 2,
    pocion_vida = true,
    pocion_mana = 4,
    pocion_mana_extra = true
  },
  
  {
    peso = 0.5,
    nivel_min = 1,
    enemigos = {},
    monedas = 2,
    pocion_vida = 4,
    pocion_vida_extra = true
  }
}
