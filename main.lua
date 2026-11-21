-- Game Resolution (the "virtual screen")
GAME_WIDTH  = 320
GAME_HEIGHT = 240
SCALE       = 3

-- Layout
HUD_HEIGHT  = 32
TILE_SIZE   = 16

function love.load()
  --Keeps pixels sharp when scaled up
  love.graphics.setDefaultFilter("nearest", "nearest")

  --The small canvas the whole game draws on
  canvas = love.graphics.newCanvas(GAME_WIDTH, GAME_HEIGHT)
end

function love.update(dt)
  --This is where the game logic will go when the time arrises
end

function love.draw()
  --1 Draw the game onto the small canvas
  love.graphics.setCanvas(canvas)
  love.graphics.clear(0, 0, 0)

  --HUD Strip (Dark Gray)
  love.graphics.setColor(0.10, 0.10, 0.10)
  love.graphics.rectangle("fill", 0, 0, GAME_WIDTH, GAME_HEIGHT)

  -- Playfield (green)
  love.graphics.setColor(0.2, 0.6, 0.3)
  love.graphics.rectangle("fill", 0, HUD_HEIGHT, GAME_WIDTH, GAME_WIDTH - HUD_HEIGHT)

  --One Tile-sized square in the middle (stand in for CC)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", 152, 144, TILE_SIZE, TILE_SIZE)

  --HUD Text
  love.graphics.print("CC", 8, 8)

  love.graphics.setCanvas()

  --2. Draw the canvas onto the window, scaled up
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(canvas, 0, 0, 0, SCALE, SCALE)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end
