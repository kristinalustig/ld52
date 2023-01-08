C = require "content"
F = require "farm"
CF = require "fair"
W = require "words"
P = require "plants"

lg = love.graphics
la = love.audio
lm = love.mouse

TEST = false

Scenes = 
{
  
  TITLE = 1,
  INTRO = 2,
  SEEDCHOICE = 3,
  FARM = 4,
  REVEAL = 5,
  BARN = 6,
  MORNING = 7,
  FAIR = 8,
  RESULTS = 9,
  PREFAIR = 10,
  INTRO2 = 11,
  PAUSE = 12
  
}

currentScene = nil


function love.load()
  
  currentScene = Scenes.TITLE
  
  C.init()
  W.init()
  P.init()
  F.init()
  CF.init()
  
end

function love.update()

  CF.update()
  C.update()
  
end

function love.draw()
  
  C.draw() --try to make this the only draw call
  
  
  if TEST then 
    lg.printf("("..lm.getX()..", "..lm.getY()..")", lm.getX()+10, lm.getY()+10, 80, "left")
  end
  
end

function love.mousepressed(x, y)
  
  --here we can start drag events for handling plants, water, etc. as well as words in the fair scene
  C.handleMouseClick(x, y)
  
end

function love.mousereleased(x, y)
  
  C.handleMouseRelease(x, y)
  
end

function love.keypressed(key, scancode, isrepeat)
  
  C.handleKeyPress(key)
  
end
