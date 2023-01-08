local F = require "farm"
local U = require "utils"
local CF = require "fair"

C = {}


--screens
local farmBackground --image
local barnBackground --image
local titleScreen --image
local seedChoiceScreen --image
local fairScreen --image
local scoreScreen --image
local intro1Screen --image
local intro2Screen --image
local pauseScreen --image
local resultsScreen --image
local countdownBg --image


--images
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
local scoreBadges --spritesheet

local doneBadge --quad
local eodOverlay --image
local wordCards --image
local preFairBg --image

--sprite quad tables
local cropQuads = {}
local fruitQuads = {}

--fonts
local plantFont
local dialogFont
local timerFont
local timerBigFont
local floorFont
local lilFont
local resultsFont

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
local wordCardQuads = {}
local colorTextDisplayTime
local gameResults
local gameScore
local badgeQuads

--bools
local showEodOverlay
local allOpened
local confirmFinished
local timeAtEnd
local showNumberWarning

function C.init()
  
  
  --screens
  farmBackground = lg.newImage("/assets/background.png")
  barnBackground = lg.newImage("/assets/barn-bg.png")
  fairScreen = lg.newImage("/assets/fair-screen-a.png")
  seedChoiceScreen = lg.newImage("/assets/seed-choice-screen.png")
  eodOverlay = lg.newImage("/assets/eod-overlay.png")
  intro1Screen = lg.newImage("/assets/intro-1.png")
  intro2Screen = lg.newImage("/assets/intro-2.png")
  preFairBg = lg.newImage("/assets/pre-fair.png")
  titleScreen = lg.newImage("/assets/title.png")
  pauseScreen = lg.newImage("/assets/pause-bg.png")
  resultsScreen = lg.newImage("/assets/resultsBg.png")
  countdownBg = lg.newImage("/assets/countdownBg.png")
  
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
  wordCards = lg.newImage("/assets/wordCards.png")
  scoreBadges = lg.newImage("/assets/medals.png")
  
  doneBadge = lg.newQuad(0, 0, 80, 80, 720, 160)
  
  plantFont = lg.newFont("/assets/Jua-Regular.ttf", 20)
  plantFontSm = lg.newFont("/assets/Jua-Regular.ttf", 16)
  dialogFont = lg.newFont("/assets/Acme-Regular.ttf", 20)
  timerFont = lg.newFont("/assets/Acme-Regular.ttf", 40)
  timerBigFont = lg.newFont("/assets/Acme-Regular.ttf", 100)
  floorFont = lg.newFont("/assets/Acme-Regular.ttf", 30)
  lilFont = lg.newFont("/assets/BenchNine-Regular.ttf", 20)
  resultsFont = lg.newFont("/assets/Acme-Regular.ttf", 24)
  
  showEodOverlay = false
  allOpened = false
  confirmFinished = false
  showNumberWarning = false
  
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
  
  wordCardQuads = {
    lg.newQuad(0, 0, 105, 32, 105, 96),
    lg.newQuad(0, 32, 105, 32, 105, 96),
    lg.newQuad(0, 64, 105, 32, 105, 96)
  }
  
  badgeQuads = {
    lg.newQuad(0, 0, 144, 144, 288, 288),
    lg.newQuad(144, 0, 144, 144, 288, 288),
    lg.newQuad(0, 144, 144, 144, 288, 288),
    lg.newQuad(144, 144, 144, 144, 288, 288)
    }
  
  colorTextDisplayTime = 2
  
end

function C.update()
  
  local mx, my = love.mouse.getPosition()
  
  if currentScene == Scenes.FARM and not showEodOverlay then
    CheckHoverStates(mx, my)
    F.update()
    currentCrops = F.getCurrentPlantInfo()
    showEodOverlay = F.getComplete() or F.getTimeUp()
    if showEodOverlay then
      timeAtEnd = F.getTimeUp()
    end
  end
  
  if currentScene == Scenes.FAIR then
    if CF.checkPlaced() then
      confirmFinished = true
    end
  end
  
  if dog.textTimer then
    local timeElapsed = love.timer.getTime() - dog.textTimer
    if timeElapsed > colorTextDisplayTime then
      dog.textTimer = false
    end
  end
  
  if scarecrow.textTimer then
    local timeElapsed = love.timer.getTime() - scarecrow.textTimer
    if timeElapsed > colorTextDisplayTime then
      scarecrow.textTimer = false
    end
  end
  
end

function C.draw()
  
  if currentScene == Scenes.FARM then
    DrawFarm()
    if showEodOverlay then
      DrawEODOverlay(not timeAtEnd)
    end
  elseif currentScene == Scenes.BARN then
    DrawBarn()
  elseif currentScene == Scenes.MORNING then
    DrawSeedSelection()
  elseif currentScene == Scenes.FAIR then
    DrawFair()
  elseif currentScene == Scenes.TITLE then
    lg.draw(titleScreen)
  elseif currentScene == Scenes.INTRO then
    lg.draw(intro1Screen)
  elseif currentScene == Scenes.INTRO2 then
    lg.draw(intro2Screen)
  elseif currentScene == Scenes.PREFAIR then
    lg.draw(preFairBg)
  elseif currentScene == Scenes.PAUSE then
    lg.draw(pauseScreen)
  elseif currentScene == Scenes.RESULTS then
    lg.draw(resultsScreen)
    lg.setFont(resultsFont)
    lg.setColor(0, 0, 0)
    lg.printf(gameResults, 100, 100, 510, "center")
    lg.reset()
    lg.draw(scoreBadges, GetScoreBadge(gameScore), 120, 400)
    lg.setFont(dialogFont)
    lg.setColor(0, 0, 0)
    lg.printf("Your score was "..gameScore.." points.", 250, 410, 300, "left")
    lg.printf("Great work, thanks for playing!", 250, 430, 300, "left")
    lg.reset()
  end
  
end

function GetScoreBadge(s)
  
  if s > 100 then
    --A
    return badgeQuads[1]
  elseif s > 80 then
    --B
    return badgeQuads[2]
  elseif s > 60 then
    return badgeQuads[3]
  else
    --D
    return badgeQuads[4]
  end
  
end


function DrawFair()
  
  lg.draw(fairScreen)
  
  local inTray = CF.getStillInTray()
  
  for k, v in ipairs(inTray) do
    local w = v.w
    if v.alt then
      w = v.altw
    end
    lg.draw(wordCards, wordCardQuads[v.c], v.x, v.y)
    lg.setColor(0, 0, 0)
    lg.printf(w, v.x, v.y+10, 105, "center")
    lg.reset()
    if #v.addCoords > 0 then
      for k1, v1 in ipairs(v.addCoords) do
        local w1 = v.w
        if v1[3] then
          w1 = v.altw
        end
        lg.draw(wordCards, wordCardQuads[v.c], v1[1], v1[2])
        lg.setColor(0, 0, 0)
        lg.printf(w1, v1[1], v1[2]+10, 105, "center")
        lg.reset()
      end
    end
    lg.reset()
  end
  
  if confirmFinished then
    lg.setFont(dialogFont)
    lg.printf("You finished your story - press 'enter' to submit and get your score!", 10, 560, 780, "center")
    lg.reset()
  end
  
end

function DrawSeedSelection()
  
  lg.draw(seedChoiceScreen)
  
  local plantsInStorage = F.getAllPlants()
  local n, v, a = GetCounts(plantsInStorage)
  
  local gn, gv, ga = GetCounts(CF.getThemeCoords())
  
  lg.setFont(dialogFont)
  
  lg.printf(seedsToPlant.n, 290, 328, 40, "left")
  lg.printf(seedsToPlant.a, 290, 402, 40, "left")
  lg.printf(seedsToPlant.v, 290, 476, 40, "left")
  
  lg.printf(n, 490, 328, 40, "left")
  lg.printf(a, 490, 402, 40, "left")
  lg.printf(v, 490, 476, 40, "left")
  
  lg.printf(gn, 660, 328, 40, "left")
  lg.printf(ga, 660, 402, 40, "left")
  lg.printf(gv, 660, 476, 40, "left")
  
  lg.printf("'A fairy tale adventure'", 210, 548, 300, "left")
  
  if showNumberWarning then
    lg.setFont(dialogFont)
    lg.printf("Total seeds must be exactly 6", 563, 525, 200, "left")
    lg.reset()
  end
  
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
  
  local daysLeft = F.getDaysLeft
  local bottomText = "Great! Now press 'enter' to continue to the barn."
  
  if daysLeft <= 1 then
    bottomText = "Great - that was our last harvest! Press 'enter' to go to the fair!"
  end
  
  lg.reset()
  lg.setFont(dialogFont)
  local text = "That's it for the day's harvest!"
  
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
    if v.plantStage < 4 then
      c = c + 6
    elseif not v.harvested and v.plantStage >= 5 then
      c = c + 3
    end
    
    lg.draw(fruitSprites, fruitQuads[c], overlayLocations[k].x, overlayLocations[k].y)
    
    if v.opened then
      if v.plantStage < 4 then
        c = c - 6
      end
      lg.draw(fruitSprites, fruitQuads[c+9], overlayLocations[k].x+110, overlayLocations[k].y-20)
      
      lg.setColor(17/225, 80/225, 15/225)
      
      
      if #v.word >= 10 then
        lg.setFont(plantFontSm)
      else
        lg.setFont(plantFont)
      end
      lg.printf(v.word, overlayLocations[k].x+112, overlayLocations[k].y + 50, 100, "center")
      lg.reset()
    else
      allOpenedL = false
    end
  end
  
  if allOpenedL then
    allOpened = true
    lg.setColor(17/225, 80/225, 15/225) 
    lg.setFont(dialogFont)
    lg.printf(bottomText, 52, 430, 600, "left")
    lg.reset()
  end
  
end

function FinishDay()
  
  showEodOverlay = false
  local daysLeft = F.finishFarmDay()
  if daysLeft == 0 then
    currentScene = Scenes.PREFAIR
    CF.startFair()
  else
    currentScene = Scenes.BARN
  end
  
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
    if TEST then
        lg.setFont(timerFont)
        lg.setColor(0, 0, 0)
        lg.printf(v.score, crops[k].x + xOffset, crops[k].y + yOffset, 100, "center")
        lg.reset()
      end
  end
  
  if not showEodOverlay then
    lg.setFont(timerFont)
    lg.setColor(0, 0, 0)
    lg.printf(math.floor(F.getTimeLeft()), 612, 523, 50, "center")
  end
  local daysLeft = F.getDaysLeft()
  local txt = ""
  if daysLeft == 3 then
    txt = "Day 1 of 3"
  elseif daysLeft == 2 then
    txt = "Day 2 of 3"
  elseif daysLeft == 1 then
    txt = "Last day!"
  end
  lg.setColor(1, 1, 1)
  lg.setFont(floorFont)
  lg.printf(txt, 100, 100, 180, "center")
  lg.reset()
  
  if dog.textTimer then
    lg.setFont(lilFont)
    lg.printf("- "..dog.textChosen, 630, 372, 200, "left")
  end
  
  if scarecrow.textTimer then
    lg.setFont(lilFont)
    lg.printf(scarecrow.textChosen.." -", 560, 474, 140, "right")
  end
  
  local cd = F.getCurrentlyDragging()
  if cd ~= nil then
    ShowDraggingItem(cd)
  end
  
  local countdown = F.getTimeLeft()
  if countdown > 61 then
    lg.draw(countdownBg)
    lg.setColor(1, 243/255, 135/255)
    lg.setFont(timerBigFont)
    lg.printf(math.floor(countdown-60), 0, 240, 800, "center")
    lg.reset()
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
  
  return 8
  
  
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
        return
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
      if seedsToPlant.a + seedsToPlant.n + seedsToPlant.v ~= 6 then
        showNumberWarning = true
      else
        currentScene = Scenes.FARM
        F.newDaySetup(seedsToPlant)
        showNumberWarning = false
      end
    end
    return
  elseif currentScene == Scenes.FAIR then
    CF.handleMouseClick(mx, my)
    return
  end
  
  --truck
  if U.detectOverlap(truck.x, truck.y, truck.x2, truck.y2, mx, my) then
    F.handleMouseClick("truck", nil)
  --dog
  elseif U.detectOverlap(dog.x, dog.y, dog.x2, dog.y2, mx, my) then
    dog.textTimer = love.timer.getTime()
    local r = love.math.random(#dog.textOptions)
    dog.textChosen = dog.textOptions[r]
  --scarecrow
  elseif U.detectOverlap(scarecrow.x, scarecrow.y, scarecrow.x2, scarecrow.y2, mx, my) then
    scarecrow.textTimer = love.timer.getTime()
    local r = love.math.random(#scarecrow.textOptions)
    scarecrow.textChosen = scarecrow.textOptions[r]
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
  
  if currentScene == Scenes.FAIR then
    CF.handleMouseRelease(mx, my)
    return
  end
  
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
    FinishDay()
  elseif currentScene == Scenes.FARM and k == "escape" then
    currentScene = Scenes.PAUSE
    F.pauseScene(true)
  elseif currentScene == Scenes.PAUSE and (k == "escape" or k == "return") then
    currentScene = Scenes.FARM
    F.pauseScene(false)
  elseif currentScene == Scenes.INTRO and k == "return" then
    currentScene = Scenes.INTRO2
  elseif currentScene == Scenes.TITLE and k == "return" then
    currentScene = Scenes.INTRO
  elseif currentScene == Scenes.INTRO2 and k == "return" then
    StartDay()
    currentScene = Scenes.FARM
  elseif currentScene == Scenes.BARN and k == "return" then
    StartDay()
    currentScene = Scenes.MORNING
  elseif currentScene == Scenes.PREFAIR and k == "return" then
    currentScene = Scenes.FAIR
  elseif currentScene == Scenes.FAIR and confirmFinished then
    gameScore = CF.getStoryScore()
    gameResults = FormatResults(CF.generateResults())
    currentScene = Scenes.RESULTS
  end
  
end

function FormatResults(r)
  
  local str = ""
  
  for k, v in ipairs(r) do
    if type(v) ~= "string" then
      local c = CF.getCardById(v[6])
      local w = c.w
      if v[3] == true then
        w = c.altw
      end
      str = str..w
    else
      str = str..v
    end
  end
  
  return str
  
end


function StartDay()
  
  F.startDay()
  
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
  dog.textTimer = false
  dog.textChosen = nil
  dog.textOptions = 
  {
    "woof! i love words!",
    "bork, my name's willow!",
    "this fertilizer smells GOOD",
    "can i have a snack?",
    "words need water to grow!"
    }
  
  barn.x = 485
  barn.y = 0
  barn.x2 = 780
  barn.y2 = 130
  
  scarecrow.x = 699
  scarecrow.y = 467
  scarecrow.x2 = 755
  scarecrow.y2 = 580
  scarecrow.textTimer = false
  scarecrow.textChosen = nil
  scarecrow.textOptions = 
  {
    "my back is itchy",
    "no birds here!",
    "why do u click so much",
    "i'm so fashionable",
    "i'm standing guard!"
    }
  
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