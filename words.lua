W = {}

local nounTable = {}
local verbTable = {}
local adTable = {}
local numThemes = 2
local wordsUsed = {}

--table structure = word type id, word, plural/gerund (or nil), specific word type, theme

function W.init()
  
  for i=1, numThemes do
    nounTable[i] = {}
    adTable[i] = {}
    verbTable[i] = {}
  end
  
  for line in love.filesystem.lines("/assets/words.txt") do
    local t = SplitLinesByComma(line)
    local tIndex = tonumber(t[5])
    t[1] = tonumber(t[1])
    if t[1] == 1 then
      table.insert(nounTable[tIndex], t)
    elseif t[1] == 2 then
      table.insert(adTable[tIndex], t)
    elseif t[1] == 3 then
      table.insert(verbTable[tIndex], t)
    end
  end
  
end

--gets a word from the available list for the current theme
function W.getWord(plantType, currentTheme, goodWord)
  
  local useTheme = currentTheme
  if not goodWord then
    useTheme = 2
  end
  
  local wordFound = false
  local word = nil
  local tries = 0
  
  while wordFound == false and tries < 10 do
    if plantType == "noun" then
      local r = love.math.random(#nounTable[useTheme])
      word = nounTable[useTheme][r][2]
    elseif plantType == "ad" then
      local r = love.math.random(#adTable[useTheme])
      word = adTable[useTheme][r][2]
    elseif plantType == "verb" then
      local r = love.math.random(#verbTable[useTheme])
      word = verbTable[useTheme][r][2]
    end
    
    if not WordUsed(word) then
      wordFound = true
    else
      tries = tries + 1
    end
  end
  
  table.insert(wordsUsed, word)
  return word
  
end

function WordUsed(w)
  
  for k, v in ipairs(wordsUsed) do
    
    if v == w then
      return true
    end
    
  end
  
  return false
  
end


function SplitLinesByComma(line)
  
  local values = {}
  for value in line:gmatch("[^,]+") do
    if value:sub(#value, #value) == " " then
      value = value:sub(1, #value-1)
    end
    table.insert(values, value)
  end
  return values
  
end

return W