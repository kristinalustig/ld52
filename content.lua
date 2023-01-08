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
local eodOverlay

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
local overlayLocations = {}
local seedsToPlant = {}
local seedButtonLocs = {}

--bools
local showEodOverlay
local allOpened

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
  eodOverlay = lg.newImage("/assets/eod-overlay.png")
  
  doneBadge = lg.newQuad(0, 0, 80, 80, 720, 160)
  
  plantFont = lg.newFont("/assets/Jua-Regular.ttf", 20)
  dialogFont = lg.newFont("/assets/Acme-Regular.ttf", 20)
  
  showEodOverlay = false
  allOpened = false
  
  InitCropQuads()
  InitFruitQuads()
  InitPlantBadges()
  
  InitObjectPlacement()
  
  InitOverlayPlacement()
  
  seedsToPlant = {
    n = 2,
    a = 2,
    v = 2
  }
  
  seedButtonLocs = {
    {{x = 226,
      y = 325,
      x2 = 262,
      y2 = 362},
    {x = 332,
      y = 325,
      x2 = 366,
      y2 = 362}},
    {{x = 226,
      y = 400,
      x2 = 262,
      y2 = 436},
    {x = 332,
      y = 400,
      x2 = 366,
      y2 = 436}},
    {{x = 226,
      y = 476,
      x2 = 262,
      y2 = 512},
    {x = 332,
      y = 476,
      x2 = 366,
      y2 = 512}}
  }
  
end

function C.update()
  
  local mx, my = love.mouse.getPosition()
  
  CheckHoverStates(mx, my)
  
  if currentScene == Scenes.FARM and not showEodOverlay then
    F.update()
  end
  
  currentCrops = F.getCurrentPlantInfo()
  
  showEodOverlay = F.getComplete() or F.getTimeUp()
  
end

function C.draw()
  
  if currentScene == Scenes.FARM then
    
    DrawFarm()
    
    if showEodOverlay then
      DrawEODOverlay(true)
    end
    
  elseif currentScene == Scenes.BARN then
    
    DrawBarn()
    
  elseif currentScene == Scenes.MORNING then
    
    DrawSeedSelection()
    
  end
  
end

function DrawSeedSelection()
  
  lg.draw(seedChoiceScreen)
  
  local plantsInStorage = F.getAllPlants()
  local n, v, a = GetCounts(plantsInStorage)
  
  lg.setFont(dialogFont)
  
  lg.printf(seedsToPlant.n, 290, 328, 40, "left")
  lg.printf(seedsToPlant.a, 290, 402, 40, "left")
  lg.printf(seedsToPlant.v, 290, 476, 40, "left")
  
  lg.printf(n, 490, 328, 40, "left")
  lg.printf(a, 490, 402, 40, "left")
  lg.printf(v, 490, 476, 40, "left")
  
  lg.printf(n, 660, 328, 40, "left")
  lg.printf(a, 660, 402, 40, "left")
  lg.printf(v, 660, 476, 40, "left")
  
  lg.printf("'A fairy tale adventure'", 210, 548, 300, "left")
  
end

function DrawBarn()
  
  lg.draw(barnBackground)
  local plantsInStorage = F.getAllPlants()
  
  
  local nPos = 112
  local nouns = ""
  local aPos = 112
  local ads = ""
  local vPos = 112
  local verbs = ""
  lg.setFont(dialogFont)
  for k, v in ipairs(plantsInStorage) do
    if v.plantType == "noun" then
      lg.draw(fruitSprites, fruitQuads[GetFruit(v.cropNum, v.plantStage)], nPos, 103)
      if #nouns ~= 0 then
        nouns = nouns..", "..v.word
      else
        nouns = v.word
      end
      nPos = nPos + 60
    elseif v.plantType == "ad" then
      lg.draw(fruitSprites, fruitQuads[GetFruit(v.cropNum, v.plantStage)], aPos, 224)
      if #ads ~= 0 then
        ads = ads..", "..v.word
      else
        ads = v.word
      end
      aPos = aPos + 60
    elseif v.plantType == "verb" then
      lg.draw(fruitSprites, fruitQuads[GetFruit(v.cropNum, v.plantStage)], vPos, 350)
      if #verbs ~= 0 then
        verbs = verbs..", "..v.word
      else
        verbs = v.word
      end
      vPos = vPos + 60
    end
  end
  
  local n, v, a = GetCounts(plantsInStorage)
  lg.printf(n .." nouns: "..nouns, 545, 115, 200, "left")
  lg.printf(a .." advs/adjs: "..ads, 545, 241, 200, "left")
  lg.printf(v .." verbs: "..verbs, 545, 368, 200, "left")
  
  lg.printf("Press 'enter' to start a new day", 50, 520, 200, "center")
  
end


function GetCounts(plants)
  local n = 0
  local v = 0
  local a = 0
  
  for k, va in ipairs(plants) do
    if va.plantType == "noun" then
      n = n + 1
    elseif va.plantType == "ad" then
      a = a + 1
    else
      v = v + 1
    end
  end
  
  return n, v, a
  
end


function DrawEODOverlay(finishedEarly)
  
  lg.reset()
  lg.setFont(dialogFont)
  local text = "THat's it for the day's harvest!"
  
  lg.draw(eodOverlay)
  if finishedEarly then
    text = "You harvested all the wordfruit today!"
  end
  
  lg.setColor(17/225, 80/225, 15/225) 
  lg.printf(text.." To open up the fruit and reveal the words you've grown, click on each fruit.", 52, 53, 600, "left")
  lg.reset()
  lg.setFont(plantFont)
  
  local allOpenedL = true

  for k, v in ipairs(currentCrops) do
    local c = v.cropNum
    if v.plantStage <= 4 then
      c = c + 6
    elseif not v.harvested and v.plantStage >= 5 then
      c = c + 3
    end
    
    lg.draw(fruitSprites, fruitQuads[c], overlayLocations[k].x, overlayLocations[k].y)
    
    if v.opened then
      if v.plantStage <= 4 then
        c = c - 6
      end
      lg.draw(fruitSprites, fruitQuads[c+9], overlayLocations[k].x+100, overlayLocations[k].y-20)
      
      lg.setColor(17/225, 80/225, 15/225) 
      lg.setFont(plantFont)
      lg.printf(v.goodWord, overlayLocations[k].x+105, overlayLocations[k].y + 50, 100, "center")
      lg.reset()
    else
      allOpenedL = false
    end
  end
  
  if allOpenedL then
    allOpened = true
    lg.setColor(17/225, 80/225, 15/225) 
    lg.setFont(dialogFont)
    lg.printf("Great! Now press 'enter' to continue to the barn.", 52, 430, 600, "left")
    lg.reset()
  end
  
end

function FinishDay()
  
  showEodOverlay = false
  F.finishFarmDay()
  
end

function DrawFarm()
  
  lg.draw(farmBackground)
  
  if currentlyHighlighted then
    HighlightObject()
  end

  local xOffset = 30
  local yOffset = 40
  currentCrops = F.getCurrentPlantInfo()
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
  
  if currentScene == Scenes.FARM and not showEodOverlay then

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
  
  if showEodOverlay then
    for k, v in ipairs(currentCrops) do
      if U.detectOverlap(overlayLocations[k].x, overlayLocations[k].y, overlayLocations[k].x+ overlayLocations[k].w, overlayLocations[k].y+overlayLocations[k].w, mx, my) then
        v.opened = true
      end
    end
    return
    
  elseif currentScene == Scenes.MORNING then
    for k, v in ipairs(seedButtonLocs) do
      if U.detectOverlap(v[1].x, v[1].y, v[1].x2, v[1].y2, mx, my) then
        if seedsToPlant.n + seedsToPlant.a + seedsToPlant.v >= 6 then
          return
        end
        if k == 1 then
          seedsToPlant.n = seedsToPlant.n + 1
        elseif k == 2 then
          seedsToPlant.a = seedsToPlant.a + 1
        elseif k == 3 then
          seedsToPlant.v = seedsToPlant.v + 1
        end
      end
      if U.detectOverlap(v[2].x, v[2].y, v[2].x2, v[2].y2, mx, my) then
        if k == 1 and seedsToPlant.n > 0 then
          seedsToPlant.n = seedsToPlant.n - 1
        elseif k == 2 and seedsToPlant.a > 0 then
          seedsToPlant.a = seedsToPlant.a - 1
        elseif k == 3 and seedsToPlant.v > 0 then
          seedsToPlant.v = seedsToPlant.v - 1
        end
      end
    end
    
    if U.detectOverlap(563, 544, 758, 590, mx, my) then
      currentScene = Scenes.FARM
      F.newDaySetup(seedsToPlant)
    end
    return
  end
  
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

function C.handleKeyPress(k)
  
  if showEodOverlay and currentScene == Scenes.FARM and allOpened and k == "return" then
    F.finishFarmDay()
    currentScene = Scenes.BARN
  elseif currentScene == Scenes.INTRO and k == "return" then
    currentScene = Scenes.FARM
  elseif currentScene == Scenes.TITLE and k == "return" then
    currentScene = Scenes.INTRO
  elseif currentScene == Scenes.BARN and k == "return" then
    currentScene = Scenes.MORNING
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

function InitOverlayPlacement()
  
  local xStart = 76
  local yStart = 100
  for i = 0, 2 do
    for j = 0, 1 do
      table.insert(overlayLocations, {
          x = xStart+(j*280),
          y = yStart +(i*100),
          w = 120
        })
    end
  end
  
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