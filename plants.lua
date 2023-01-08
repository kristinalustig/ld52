P = {}

local id
local currentTheme

function P.init()
  
  id = 1
  currentTheme = 1
  
end

function P.createPlant(plantType)
  
  local tempTable = {}
  tempTable.id = id
  tempTable.plantType = plantType
  tempTable.goodWord, tempTable.altGood = W.getWord(plantType, currentTheme, true)
  tempTable.badWord, tempTable.altBad = W.getWord(plantType, currentTheme, false)
  tempTable.score = 0
  tempTable.needs = GetPlantNeeds()
  tempTable.currentNeed = nil
  tempTable.initialDelay = love.math.random(10)
  tempTable.timer = 0
  tempTable.timeLeft = 0
  tempTable.needMet = false
  tempTable.tasksCompleted = 0
  tempTable.plantStage = 1
  tempTable.showBadgeTimer = 0
  tempTable.badgeState = nil
  tempTable.cropNum = GetCropNum(plantType)
  tempTable.harvested = false
  tempTable.opened = false
  
  id = id + 1
  
  return tempTable
  
end

function GetPlantNeeds()
  
  local modifier1 = math.random(2, 3)
  local modifier2 = math.random(2, 3)
  
  local tempTable = {}
  tempTable.water = modifier1
  tempTable.fertilizer = modifier2
  
  return tempTable
  
end

function GetCropNum(plantType)
  
  if plantType == "noun" then
    return 1
  elseif plantType == "ad" then
    return 2
  elseif plantType == "verb" then
    return 3
  end
  
end

return P