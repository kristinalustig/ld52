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
local doneBadge --quad

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
local plantNeedBadges = {}
local timeLeftBadges = {}
local resultBadges = {}

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
  
  doneBadge = lg.newQuad(0, 0, 80, 80, 720, 160)
  
  plantFont = lg.newFont("/assets/Jua-Regular.ttf", 20)
  dialogFont = lg.newFont("/assets/Acme-Regular.ttf", 20)
  
  InitCropQuads()
  InitFruitQuads()
  InitPlantBadges()
  
  InitObjectPlacement()
  
  InitCrops()
  
end

function C.update()
  
  local mx, my = love.mouse.getPosition()
  
  CheckHoverStates(mx, my)
  
  currentCrops = F.getCurrentPlantInfo()
  
end

function C.draw()
  
  if currentScene == Scenes.FARM then
    lg.draw(farmBackground)
    
    if currentlyHighlighted then
      HighlightObject()
    end
  
    local xOffset = 30
    local yOffset = 40
    for k, v in ipairs(currentCrops) do
      local img = cropQuads[((v.cropNum-1)*6) + v.plantStage]
      if v.isDragging and v.plantStage >= 5 then
        img = cropQuads[((v.cropNum-1)*6) + 4]
        lg.draw(fruitSprites, fruitQuads[GetFruit(v.cropNum, v.plantStage)], lm.getX(), lm.getY())
      end
      lg.draw(cropSprites, img, crops[k].x-5, crops[k].y-5)
      if v.currentNeed ~= nil then
        local b = 3
        if v.currentNeed == "water" then
          b = 1
        elseif v.currentNeed == "fertilizer" then
          b = 2
        end
        
        lg.draw(cropBadges, plantNeedBadges[b], crops[k].x + xOffset, crops[k].y + yOffset)
        lg.setColor(1, 1, 1, .5)
        lg.draw(cropBadges, timeLeftBadges[GetTimeLeftBadge(v.timeLeft)], crops[k].x + xOffset, crops[k].y + yOffset)
        lg.reset()
      end
      if v.showBadgeTimer > 0 then
        lg.draw(cropBadges, resultBadges[v.badgeState], crops[k].x + xOffset, crops[k].y + yOffset)
      end
      if v.harvested then
        lg.draw(cropBadges, doneBadge, crops[k].x + xOffset, crops[k].y + yOffset)
      end
    end
    
    lg.setFont(dialogFont)
    lg.printf(math.floor(F.getTimeLeft()), 610, 529, 50, "left")
    
    local cd = F.getCurrentlyDragging()
    if cd ~= nil then
      ShowDraggingItem(cd)
    end
    
  end
  
end

function GetTimeLeftBadge(t)
  
  local tpt = F.getTimePerTask()
  t = tpt - t
  for i = 1, 8 do
    if t <= (tpt/8)*i then
      return i
    end
  end
  
  
end

function GetFruit(n, p)
  
  if p == 3 then 
    return n + 6
  elseif p == 5 then
    return n
  else
    return n + 3
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

function ShowDraggingItem(obj)
  
  if obj == "fertilizer" then
    lg.draw(manureBlob, lm.getX(), lm.getY())
  elseif obj == "water" then
    lg.draw(waterBlob, lm.getX(), lm.getY())
  elseif obj == "crop" then
    
  end
  
end


function C.handleMouseClick(mx, my)
  
  --truck
  if U.detectOverlap(truck.x, truck.y, truck.x2, truck.y2, mx, my) then
    F.handleMouseClick("truck", nil)
  --dog
  elseif U.detectOverlap(dog.x, dog.y, dog.x2, dog.y2, mx, my) then
    F.handleMouseClick("dog", nil)
  --scarecrow
  elseif U.detectOverlap(scarecrow.x, scarecrow.y, scarecrow.x2, scarecrow.y2, mx, my) then
    F.handleMouseClick("scarecrow", nil)
    --well
  elseif U.detectOverlap(well.x, well.y, well.x2, well.y2, mx, my) then
    F.handleMouseClick("well", nil)
  --crops
  else
    for k, v in ipairs(crops) do
      if U.detectOverlap(v.x, v.y, v.x2, v.y2, mx, my) then
        F.handleMouseClick("crop", k)
        return
      end
    end
  end
  
end

function C.handleMouseRelease(mx, my)
  
  --barn
  if U.detectOverlap(barn.x, barn.y, barn.x2, barn.y2, mx, my) then
    F.handleMouseRelease("barn", nil)
  --crops
  else
    for k, v in ipairs(crops) do
      if U.detectOverlap(v.x, v.y, v.x2, v.y2, mx, my) then
        F.handleMouseRelease("crop", k)
        return
      end
    end
    F.handleMouseRelease("none", nil)
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

function InitPlantBadges()
  
  table.insert(plantNeedBadges, lg.newQuad(80, 0, 80, 80, 720, 160))
  table.insert(plantNeedBadges, lg.newQuad(160, 0, 80, 80, 720, 160))
  table.insert(plantNeedBadges, lg.newQuad(240, 0, 80, 80, 720, 160))
  
  table.insert(resultBadges, lg.newQuad(320, 0, 80, 80, 720, 160))
  table.insert(resultBadges, lg.newQuad(400, 0, 80, 80, 720, 160))
  table.insert(resultBadges, lg.newQuad(480, 0, 80, 80, 720, 160))
  table.insert(resultBadges, lg.newQuad(560, 0, 80, 80, 720, 160))
  table.insert(resultBadges, lg.newQuad(640, 0, 80, 80, 720, 160))
  
  for i=0, 7 do
    table.insert(timeLeftBadges, lg.newQuad(i*80, 80, 80, 80, 720, 160))
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