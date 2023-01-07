local U = require "utils"
local P = require "plants"

F = {}

local timePerRound --int
local timeLeft --int
local currentlyDragging --object
local plantsGrowing --objects table
local isDialogShowing --bool
local currentTheme
local farmName

function F.init()
  
  timePerRound = 60
  timeLeft = timePerRound
  currentlyDragging = nil
  isDialogShowing = false
  currentTheme = 1
  plantsGrowing = InitFirstPlants()
  
end


function F.update()
  
  --update the plants as necessary
  UpdatePlantNeeds()
  
end


--called from main depending on current scene
function F.handleMouseClick(mx, my)
  
  
  
end

--called from main depending on current scene
function F.handleMouseRelease(mx, my)
  
  
end


--call at the end of each "night" scene
function ResetDay()
  
  
  
end

function AdvanceDialog()
  
  
  
end

function InitFirstPlants()
  
  plantsGrowing = 
  {
    P.createPlant("noun"),
    P.createPlant("noun"),
    P.createPlant("ad"),
    P.createPlant("ad"),
    P.createPlant("verb"),
    P.createPlant("verb")
  }
  
end

function UpdatePlantNeeds()
  
  for k, v in ipairs(plantsGrowing) do
    if timePerRound - timeLeft > v.initialDelay then
      if v.currentNeed == nil then
        local r = love.math.random(2)
        if r == 1 and tempTable.water > 1 then
          tempTable.water = tempTable.water - 1
          v.currentNeed = "water"
          v.initialDelay = v.initialDelay + 4 + love.math.random(10)
          v.timer = love.timer.getTime()
        elseif r == 2 and tempTable.fertilizer > 1 then
          tempTable.fertilizer = tempTable.fertilizer - 1
          v.currentNeed = "fertilizer"
          v.initialDelay = v.initialDelay + 6 + love.math.random(10)
          v.timer = love.timer.getTime()
        else
          v.currentNeed == "harvest"
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
      if timeElapsed > 4 and not needMet then
        --fail
        if v.showBadgeTimer >= 0 then
          v.showBadgeTimer = 2-(timeElapsed-4)
        else
          if v.currentNeed == "harvest" then
            v.plantStage = 4
          end
          v.score = v.score - 1
          v.currentNeed = nil
          v.needMet = false
          v.timeLeft = 4
        end
      elseif timeElapsed <= 4 then
        if v.needMet then
          v.currentNeed = nil
          v.needMet = false
          v.score = v.score + math.floor(v.timeLeft)
          v.tasksCompleted = tasksCompleted + 1
          v.plantStage = F.getStage(v.tasksCompleted)
          v.timeLeft = 4
        else
          v.timeLeft = 4 - timeElapsed
        end
      end
    end
  end
  
end

function F.getTimeLeft(plantId)
  
end


function F.getCurrentNeed(plantId)
  
end


function F.getTimeLeft(plantId)
  
end


function F.getTimeLeft(plantId)
  
end

return F