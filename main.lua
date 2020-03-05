Class = require "libs.hump.class"
Vector = require "libs.hump.vector"
GS = require "libs.hump.gamestate"

require "libs.useful"



-- Set up window table with information
--  Width/height are BEFORE scaling
window = {
  width = 1280,
  height = 672,
  scale = 1
}

-- Configure to use console output
function love.conf(t)
	t.console = true
end

-- Key is pressed
function love.keypressed(key)
  -- Escape closes game instantly
  if key == "escape" and love.keyboard.isDown("lctrl","rctrl") then
    love.event.push("quit")
  
  -- Ctrl+R reloads game
  elseif key == "r" and love.keyboard.isDown("lctrl","rctrl") then
    love.load()
  end
  
  -- Set keypress and keyhold for this key to true
  keyp[key] = true
  keyh[key] = true
end

-- Get mouse presses too
function love.mousepressed(x,y,button,isTouch)
  local mouse = "mouse" .. button
  
  keyp[mouse] = true
  keyh[mouse] = true
end

function love.mousereleased(x,y,button,isTouch)
  local mouse = "mouse" .. button
  
  keyh[mouse] = false
end

-- If key is released, disable its hold state
function love.keyreleased(key)
  keyh[key] = false
end

keyp = {}
keyh = {}

-- Mouse movement table
mouse = Vector(0,0)

-- Update mouse table every mouse move
function love.mousemoved( x, y, dx, dy, istouch )
  local newMouse = Vector(dx, dy)
  
  -- Optional if statement to limit mouse movement to 
  --   only larger movements to prevent extremely small
  --   twitches from affecting gameplay
  --if newMouse:len() > 1 then
    mouse = newMouse
  --end
end

function love.load()
  -- Enable linear filtering (i hate that crap)
	love.graphics.setDefaultFilter("linear","linear",16)
  
  -- Colorado Skinny Converts To Mormonism
  love.window.setTitle( "Magic Mushroom Farmer Simulator 2020" )
  
  -- Set our window to the right size, adjusting for our current scale
  love.window.setMode(window.width * window.scale, window.height * window.scale)
  
  -- Create a canvas, without scaling
  Canvas = love.graphics.newCanvas(window.width, window.height)

  --Creating action table
  actions = {}

  --Game Timer
  gameTime = 0

  --Gamestate options

  game = require "entities.game"

  GS.switch(game)
end

score=0

myTimer=0

function love.update(dt)
  gameTime = gameTime + 1

  myTimer=myTimer+dt
  if myTimer > 5 then 
  	print(score) 
  	myTimer=myTimer-2
  end
  
  -- Actions
  actions.pause = keyp.p or keyp.escape
  actions.start = keyp["return"] or keyp.kpenter or keyp.space
  
  actions.seed = keyp.a
  actions.water = keyp.s
  actions.fertilize = keyp.d
  actions.till = keyp.f
  actions.info = keyp.g
  actions.harvest = keyp.h
  
  -- Up/Down measurement
  --  0 is none, 1 is down, -1 is up
  --actions.up = keyp.w or keyp.up
  --actions.down = keyp.s or keyp.down
  actions.UD = bti(actions.down) - bti(actions.up)
  
  --actions.left = keyp.a or keyp.left
  --actions.right = keyp.d or keyp.right
  actions.LR = bti(actions.right) - bti(actions.left)
  
  actions.skip = #keys(keyp) > 0
  
  -- Update our game function
  GS.update(dt)
  
  -- Reset keypresses
  keyp = {}
  
  -- Update info for drawing the mouse lines
  --mouseDraw.x, mouseDraw.y = mouse.x, mouse.y
  
  -- Reset mouse at end of every frame
  --   This is because of an issue I've found with my mouse,
  --   where if you accelerate quickly and then lift the mouse,
  --   Love2D won't call love.mousemoved, so the fast movement
  --   will remain as the last move indefinitely
  mouse.x, mouse.y = 0, 0
  --Canvas:clear()
end

function love.draw(dt)
	love.graphics.setDefaultFilter("nearest","nearest",1)
  love.graphics.setCanvas(Canvas)
	love.graphics.clear()
  
  GS.draw()
  
  love.graphics.setColor(1,1,1,1)
  
	love.graphics.scale(window.scale)
  love.graphics.setCanvas()
  love.graphics.draw(Canvas, 0, 0)
end