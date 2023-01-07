local F = require "farm"
local U = require "utils"

C = {}

--images
local farmBackground --image
local barnBackground --image
local dialogBox --image
local cropSprites --spritesheet
local fruitSprites --spritesheet
local cropBadges --spritesheet
local waterBlob --image
local cropHighlight --image
local barnHighlight --image
local wellHighlight --image
local truckHighlight --image
local manureBlob --image
local titleScreen --image TODO
local nightScreen --image
local seedChoiceScreen --image
local fairScreen --image
local scoreScreen --image TODO

--sprite quad tables
local cropQuads = {}
local fruitQuads = {}

--fonts
local plantFont
local dialogFont

--audio
local backgroundMusic --audio TODO
local tickTock --sfx TODO
local dingPerfect --sfx TODO
local dingGood --sfx TODO
local dingOkay --sfx TODO
local dingBad --sfx TODO
local dingFail --sfx TODO

--UI elements
local themeFooter --image, displays current theme in barn TODO
local storyParchment --image, shows story to fill in TODO

--objects
local truck = {}
local well = {}
local dog = {}
local barn = {}
local crops = {}
local scarecrow = {}
local currentlyHighlighted
local currentCrops = {}

function C.init()
  
  farmBackground = lg.newImage("/assets/background.png")
  barnBackground = lg.newImage("/assets/barn-bg.png")
  dialogBox = lg.newImage("/assets/dialog.png")
  cropSprites = lg.newImage("/assets/growing-crops.png")
  fruitSprites = lg.newImage("/assets/picked-fruit.png")
  cropBadges = lg.newImage("/assets/plant-badges.png")
  waterBlob = lg.newImage("/assets/water.png")
  cropHighlight = lg.newImage("/assets/crop-highlight.png")
  barnHighlight = lg.newImage("/assets/barn-highlight.png")
  wellHighlight = lg.newImage("/assets/well-highlight.png")
  truckHighlight = lg.newImage("/assets/truck-highlight.png")
  manureBlob = lg.newImage("/assets/manure.png")
  fairScreen = lg.newImage("/assets/fair-screen.png")
  nightScreen = lg.newImage("/assets/night-screen.png")
  seedChoiceScreen = lg.newImage("/assets/seed-choice-screen.png")
  
  plantFont = lg.newFont("/assets/Jua-Regular.ttf", 20)
  dialogFont = lg.newFont("/assets/Acme-Regular.ttf", 20)
  
  InitCropQuads()
  InitFruitQuads()
  
  InitObjectPlacement()
  
  InitCrops()
  
end

function C.update()
  
  local mx, my = love.mouse.getPosition()
  
  CheckHoverStates(mx, my)
  
end

function C.draw()
  
  if currentScene == Scenes.FARM then
    lg.draw(farmBackground)
    
    if currentlyHighlighted then
      HighlightObject()
    end
  end
  
end

function CheckHoverStates(mx, my)

  --truck
  if U.detectOverlap(truck.x, truck.y, truck.x2, truck.y2, mx, my) then
    currentlyHighlighted = truck
  --barn
  elseif U.detectOverlap(barn.x, barn.y, barn.x2, barn.y2, mx, my) then
    currentlyHighlighted = barn
    --well
  elseif U.detectOverlap(well.x, well.y, well.x2, well.y2, mx, my) then
    currentlyHighlighted = well
  --crops
  else
    for k, v in ipairs(crops) do
      if U.detectOverlap(v.x, v.y, v.x2, v.y2, mx, my) then
        currentlyHighlighted = v
        return
      end
    end
    
    currentlyHighlighted = nil
  end
  
end


function HighlightObject()
  
  local img = nil
  local x = 0
  local y = 0
  
  if currentlyHighlighted == truck then
    img = truckHighlight
  elseif currentlyHighlighted == barn then
    img = barnHighlight
  elseif currentlyHighlighted == well then
    img = wellHighlight
  else
    img = cropHighlight
    x = currentlyHighlighted.x
    y = currentlyHighlighted.y
  end

  lg.draw(img, x, y)
  
end

function InitCrops()
  
end

function InitObjectPlacement()
  
  truck.x = 636
  truck.y = 219
  truck.x2 = 800
  truck.y2 = 376
  
  well.x = 342
  well.y = 0
  well.x2 = 450
  well.y2= 103
  
  dog.x = 616
  dog.y = 400
  dog.x2 = 675
  dog.y2 = 467
  
  barn.x = 485
  barn.y = 0
  barn.x2 = 780
  barn.y2 = 130
  
  scarecrow.x = 699
  scarecrow.y = 467
  scarecrow.x2 = 755
  scarecrow.y2 = 580
  
  local cropX = 65
  local cropY = 225
  
  for i=1, 2 do
    for j = 1, 3 do
      table.insert(crops, {
        x = cropX+(160*(j-1)),
        y = cropY + ((i-1)*160),
        x2 = cropX+(160*(j-1)) + 120,
        y2 = cropY + ((i-1)*160) + 120
      })
    end
  end
  
end


function InitCropQuads()
  
  for i=0, 2 do
    for j=0, 5 do
      table.insert(cropQuads, lg.newQuad(j*160, i*160, 160, 160, 960, 480))
    end
  end
  
end

function InitFruitQuads()
  
  for i=0, 4 do
    for j=0, 2 do
      table.insert(fruitQuads, lg.newQuad(j*120, i*120, 120, 120, 360, 600))
    end
  end
  
end

return C