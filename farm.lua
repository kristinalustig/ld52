local U = require "utils"
local P = require "plants"

F = {}

local timePerRound --int
local timeLeft --int
local currentlyDragging --object
local plantsGrowing = {} --objects table
local isDialogShowing --bool
local currentTheme
local farmName
local daysLeft
local startTime
local timePerTask
local isComplete
local completedPlants = {}
local testCompletedPlants = {}
local isPaused
local pauseTime

function F.init()
  
  startTime = love.timer.getTime()
  timePerRound = 64
  timeLeft = timePerRound
  currentlyDragging = nil
  isDialogShowing = false
  currentTheme = 1
  plantsGrowing = InitFirstPlants()
  timePerTask = 8
  isComplete = false
  daysLeft = 3
  isPaused = false
  pauseTime = 0
  
end


function F.update()
  
  --update the plants as necessary
  
  if isPaused then
    return
  end
  
  UpdatePlantNeeds()
  
  timeLeft = timePerRound + (startTime - love.timer.getTime())
  
  isComplete = CheckComplete()
  
end

function F.startDay()
  
  startTime = love.timer.getTime()
  timeLeft = timePerRound
  
end

function F.pauseScene(shouldPause)
  
  if shouldPause then
    isPaused = true
    pauseTime = love.timer.getTime()
  else
    isPaused = false
    startTime = startTime - (pauseTime - love.timer.getTime())
    for k, v in ipairs(plantsGrowing) do
      if v.currentNeed ~= nil then
        v.timer = v.timer - (pauseTime - love.timer.getTime())
      end
    end
  end
  
end


function CheckComplete()
  
  local result = true

  for k, v in ipairs(plantsGrowing) do
    if v.harvested == false then
      v.word = v.badWord
      v.altWord = v.altBad
      result = false
    else
      v.word = GetWordFromScore(v.goodWord, v.badWord, v.score)
      v.altWord = GetWordFromScore(v.altGood, v.altBad, v.score)
    end
  end
  return result
  
end

function GetWordFromScore(good, bad, score)
  
  if score >= (2 * timePerTask) then
    return good
  else
    return bad
  end
  
end

function F.getComplete()
  
  return isComplete
  
end

function F.getTimeUp()
  
  return timeLeft <= 0
  
end

function F.finishFarmDay()
  
  for k, v in ipairs(plantsGrowing) do
    table.insert(completedPlants, {
        
        id = v.id,
        plantType = v.plantType,
        cropNum = v.cropNum,
        plantStage = v.plantStage,
        word = v.word,
        score = v.score
        
      })
  end
  
  plantsGrowing = {}
  timeLeft = timePerRound
  currentlyDragging = nil
  timePerTask = timePerTask - 1
  isComplete = false
  daysLeft = daysLeft - 1
  
  return daysLeft
  
end

function F.getDaysLeft()
  
  return daysLeft
  
end

function F.newDaySetup(seeds)
  
  plantsGrowing = {}
  
  for i=1, seeds.n do
    table.insert(plantsGrowing, P.createPlant("noun"))
  end
  
  for i=1, seeds.a do
    table.insert(plantsGrowing, P.createPlant("ad"))
  end
  
  for i=1, seeds.v do
    table.insert(plantsGrowing, P.createPlant("verb"))
  end
  
end

function F.getAllPlants()
  
  return completedPlants
  
end

--called from main depending on current scene
function F.handleMouseClick(obj, num)

  if obj == "truck" then
    currentlyDragging = "fertilizer"
  elseif obj == "well" then
    currentlyDragging = "water"
  elseif obj == "dog" then
  elseif obj == "scarecrow" then
  elseif obj == "crop" then
    currentlyDragging = "crop"
    plantsGrowing[num].isDragging = true
  end

end

--called from main depending on current scene
function F.handleMouseRelease(obj, num)
  
  local p = nil
  if num ~= nil then
    p = plantsGrowing[num]
  elseif currentlyDragging == "crop" then
    for k, v in ipairs(plantsGrowing) do
      if v.isDragging == true then
        p = v
        v.isDragging = false
      end
    end
  end
  
  if obj == "none" then
    currentlyDragging = nil
  elseif obj == "barn" then
    if currentlyDragging == "crop" then
      if p.currentNeed == "harvest" then
        p.needMet = true
      end
    end
  elseif obj == "crop" then
    if currentlyDragging == "water" then
      --play a sound
      if p.currentNeed == "water" and p.timeLeft >= 0 then
        p.needMet = true
      end
    elseif currentlyDragging == "fertilizer" and p.timeLeft >= 0 then 
      --play a sound
      if p.currentNeed == "fertilizer" then
        p.needMet = true
      end
    end
  end
  
  currentlyDragging = nil
  
end

function F.getCurrentlyDragging()
  
  return currentlyDragging
  
end

function F.getTimePerTask()
  
  return timePerTask
  
end

function InitFirstPlants()
  
  local tempTable = 
  {
    P.createPlant("noun"),
    P.createPlant("noun"),
    P.createPlant("ad"),
    P.createPlant("ad"),
    P.createPlant("verb"),
    P.createPlant("verb")
  }
  
  return tempTable
  
end

function UpdatePlantNeeds()
  
  for k, v in ipairs(plantsGrowing) do
    if timePerRound - timeLeft - 3 > v.initialDelay then
      if v.currentNeed == nil then
        local r = love.math.random(2)
        if r == 1 and v.needs.water >= 1 then
          v.currentNeed = "water"
          v.timer = love.timer.getTime()
        elseif r == 2 and v.needs.fertilizer >= 1 then
          v.currentNeed = "fertilizer"
          v.timer = love.timer.getTime()
        elseif v.needs.fertilizer == 0 and v.needs.water == 0 and not v.harvested then
          v.currentNeed = "harvest"
          v.plantStage = 5
          v.initialDelay = timePerRound
          v.timer = love.timer.getTime()
        end
      end
    end
  end
  
  local currentTime = love.timer.getTime()
  for k, v in ipairs(plantsGrowing) do
    if v.currentNeed ~= nil then
      local timeElapsed = currentTime - v.timer
      if timeElapsed > timePerTask and not v.needMet then
        --fail
        v.showBadgeTimer = currentTime
        v.badgeState = 5
        if v.currentNeed == "harvest" then
          v.plantStage = 6
        end
        v.score = v.score - timePerTask
        v.currentNeed = nil
        v.initialDelay = v.initialDelay + timePerTask + love.math.random(6)
        v.needMet = false
        v.timeLeft = timePerTask
      elseif v.needMet and timeElapsed <= timePerTask then
        v.showBadgeTimer = currentTime
        v.badgeState = GetBadgeState(timeElapsed)
        if v.currentNeed == "water" then
          v.needs.water = v.needs.water - 1
          v.plantStage = F.getStage(v.tasksCompleted)
        elseif v.currentNeed == "fertilizer" then
          v.needs.fertilizer = v.needs.fertilizer - 1
          v.plantStage = F.getStage(v.tasksCompleted)
        elseif v.currentNeed == "harvest" then
          v.plantStage = 4
          v.harvested = true
        end
        v.currentNeed = nil
        v.initialDelay = v.initialDelay + timeElapsed + love.math.random(6)
        v.needMet = false
        v.score = v.score + math.floor(v.timeLeft)
        v.tasksCompleted = v.tasksCompleted + 1
        v.timeLeft = timePerTask
      else
        v.timeLeft = timePerTask - timeElapsed
      end
    end
  end
  
  for k, v in ipairs(plantsGrowing) do
    if v.showBadgeTimer > 0 then
      v.showBadgeTimer = v.showBadgeTimer - (currentTime - v.showBadgeTimer)/3
    else
      v.showBadgeTimer = 0
    end
  end
  
end

function F.getCurrentPlantInfo()
  
  return plantsGrowing
  
end

function F.getStage(n)
  
  if n < 2 then
    return 1
  elseif n < 4 then
    return 3
  else
    return 5
  end
  
end

function GetBadgeState(t)
  incr = timePerTask/4
  if t <= incr then
    return 1
  elseif t <= incr*2 then
    return 2
  elseif t <= incr*3 then
    return 3
  elseif t <= incr*4 then
    return 4
  else
    return 5
  end
end

function F.getTimeLeft()
  
  return timeLeft
  
end



return F