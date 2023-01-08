U = require "utils"
F = require "farm"

CF = {}

local stillInTray = {}
local placed = {}
local theme1Coords = {}
local testCompletedPlants = {}
local currentlyDragging
local additional = {}

function CF.init()
  
  theme1Coords = 
{{'noun',1,false,288,114,false},
{'ad',1,false,480,114,false},
{'noun',2,false,117,146,false},
{'noun',3,false,375,146,false},
{'verb',1,false,96,178,false},
{'ad',2,false,442,178,false},
{'noun',1,false,283,210,false},
{'verb',1,true,428,210,false},
{'ad',3,false,450,242,false},
{'noun',4,false,122,274,false},
{'noun',2,false,436,274,false},
{'ad',4,false,322,311,false},
{'noun',4,false,164,343,false},
{'ad',5,true,269,343,false},
{'noun',5,false,474,343,false},
{'verb',2,false,175,375,false},
{'noun',4,false,314,375,false},
{'noun',4,false,495,375,false},
{'verb',3,false,96,407,false},
{'noun',1,false,244,407,false},
{'ad',6,false,419,407,false},
{'ad',7,true,201,439,false}}

  if TEST then
    completedPlants = U.createTestCompletedPlants()
    CF.placeInTray()
  end
  
  currentlyDragging = nil
  
end

function CF.update()

  CF.updateTray()

end

function CF.startFair(plants)
  
  completedPlants = F.getAllPlants()
  CF.placeInTray()
  
end

function CF.getThemeCoords()
  
  local tempTable = {}
  for k, v in ipairs(theme1Coords) do
    table.insert(tempTable, {
        plantType = v[1]
      })
    end
  return tempTable
  
end

function CF.updateTray()
  
  local x = 20
  local y = 450
  local xIncr = 110
  local yIncr = 36
  local i = 0
  for k, v in ipairs(stillInTray) do
    if v.inTray then
      v.x = x + xIncr*i
      v.y = y + yIncr
      if x + xIncr*i > 600 then
        y = y + yIncr
        x = 20
        i = 0
      else
        i = i + 1
      end
    elseif v == currentlyDragging then
      v.x = lm.getX()
      v.y = lm.getY()
    end
  end
  
end

function CF.checkPlaced()
  
  for k, v in ipairs(theme1Coords) do
    if not v[6] then
      return false
    end
  end
  
  return true
end


function CF.getStoryScore()
  
  local score = 0
  
  for k, v in ipairs(theme1Coords) do
    local c = GetCardById(v[6])
    local mul = 1
    if c.plantType == v[1] then
      mul = 2
    end
    score = score + (c.score*mul)
    
  end
  
  return score
  
end
  

function CF.placeInTray()
  
  local x = 20
  local y = 450
  local xIncr = 110
  local yIncr = 36
  local i = 0
  for k, v in ipairs(completedPlants) do
    table.insert(stillInTray, {id = v.id, x = x + xIncr*i, y = y + yIncr, c = v.cropNum, w = v.word, altw = v.altWord, inTray = true, addCoords = {}, alt = false, score = v.score, plantType = v.plantType})
    if x + xIncr*i > 600 then
      y = y + yIncr
      x = 20
      i = 0
    else
      i = i + 1
    end
  end
  
end

function CF.getStillInTray()
  
  return stillInTray
  
end

function CF.getCardById(id)
  
  return GetCardById(id)
  
end

function CF.generateResults()
  
  local t = theme1Coords
  
  local story = 
  {"Once upon a time, a ",
    t[1],
    " lived in a ",
    t[2],
    " ",
    t[3],
    ". They loved their ",
    t[4],
    " and they ",
    t[5],
    " every day. Then, something ",
    t[6],
    " happened. When the ",
    t[7],
    " was ",
    t[8],
    ", they saw from the corner of their eye a ",
    t[9],
    " ",
    t[10],
    " coming straight for the ",
    t[11],
    "! Luckily, they were very ",
    t[12],
    " and went to face the ",
    t[13],
    " ",
    t[14],
    ". With their ",
    t[15],
    ", they ",
    t[16],
    " the ",
    t[17],
    " until the ",
    t[18],
    " ",
    t[19],
    ". The ",
    t[20],
    " was so ",
    t[21],
    ", they ran ",
    t[22],
    " all the way home. The end."
  }
  
  return story
  
end

--called from content depending on current scene
function CF.handleMouseClick(mx, my)
  
  for k, v in ipairs(stillInTray) do
    if U.detectOverlap(v.x, v.y, v.x+105, v.y+32, mx, my) then
      if v.inTray == false then
        CheckOverlapWithCoords(v, mx, my, "remove")
      end
      currentlyDragging = v
      v.inTray = false
      return
    elseif v.inTray == false and #v.addCoords ~= 0 then
      local foundOne = false
      for k1, v1 in ipairs(v.addCoords) do
        if U.detectOverlap(v1[1], v1[2], v1[1]+105, v1[2]+32, mx, my) then
          v[6] = false
          foundOne = true
        end
      end
      if foundOne then
        v.addCoords = {}
        v.alt = false
        currentlyDragging = v
        v.x = mx
        v.y = my
        return
      end
    end
  end
  
  currentlyDragging = nil
  
end

function CF.handleMouseRelease(mx, my)
  
  if currentlyDragging then
    if CheckOverlapWithCoords(currentlyDragging, mx, my, "add") then
      currentlyDragging = nil
    else
      currentlyDragging.inTray = true
    end
  end
  currentlyDragging = nil
  
end

function CheckOverlapWithCoords(card, mx, my, purpose)
  for k, v in ipairs(theme1Coords) do
    
    if U.detectOverlap(v[4], v[5], v[4]+105, v[5]+32, mx, my) then
      if purpose == "add" then
        if v[6] ~= false then
          local removeIt = GetCardById(v[6])
          removeIt.inTray = true
          removeIt.addCoords = {}
          removeIt.alt = false
        end
        card.x = v[4]
        card.y = v[5]
        card.inTray = false
        if v[3] then
          card.alt = true
        end
        card.addCoords = ReconcileCoords(card.id, v[1], v[2], v[4], v[5])
        v[6] = card.id
      else
        v[6] = false
        card.addCoords = {}
        card.alt = false
      end
      return true
    end
  
  end
  
  return false
  
end

function GetCardById(id)
  
  for k, v in ipairs(stillInTray) do
    if v.id == id then
      return v
    end
  end
  
end

function ReconcileCoords(id, matchA, matchB, x, y)
  
  local tempTable = {}
  
  for k, v in ipairs(theme1Coords) do
    if v[1] == matchA and v[2] == matchB and (v[4] ~= x or v[5] ~= y) then
      local alt = false
      if v[3] then
        alt = true
      end
      v[6] = id
      table.insert(tempTable, {v[4], v[5], alt})
    end
  end
  
  return tempTable
  
end


return CF