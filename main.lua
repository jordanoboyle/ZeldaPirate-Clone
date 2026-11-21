-- Game Resolution (the "virtual screen")
GAME_WIDTH  = 320
GAME_HEIGHT = 240
Scale       = 3

-- Layout
HUD_HEIGHT  = 64
TITLE_SIZE  = 16

function love.load()
  --Keeps pixels sharp when scaled up
  love.graphics.setDefaultFilter("nearest", "nearest")

  --The small canvas the whole game draws on
  canvas = love.graphics.newCanvas(GAME_WIDTH, GAME_HEIGHT)
end

function love.update(dt)
  --This is where the game logic will go when the time arrises
end
