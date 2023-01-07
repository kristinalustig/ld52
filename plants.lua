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
  tempTable.goodWord = W.getWord(plantType, currentTheme, true)
  tempTable.badWord = W.getWord(plantType, currentTheme, false)
  tempTable.score = 0
  tempTable.needs = GetPlantNeeds()
  tempTable.currentNeed = nil
  tempTable.exists = true
  tempTable.initialDelay = love.math.random(10)
  tempTable.timer = 0
  tempTable.timeLeft = 0
  tempTable.needMet = false
  tempTable.tasksCompleted = 0
  tempTable.plantStage = 1
  tempTable.showBadgeTimer = 2
  
  id = id + 1
  
end

function GetPlantNeeds()
  
  local modifier1 = love.math.random(4)
  local modifier2 = love.math.random(4)
  
  local tempTable = {}
  tempTable.water = modifier1
  tempTable.fertilizer = modifier2
  
  return tempTable
  
end

return P