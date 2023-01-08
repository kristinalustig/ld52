W = require "words"
U = {}

function U.detectOverlap(x1, y1, x2, y2, mx, my)
  
  if mx >= x1 and mx <= x2 then
    if my >= y1 and my <= y2 then
      return true
    end
  end
  
  return false
  
end

function U.getTime()
  
  
  
end

function U.startPause()
  
end

function U.endPause()
  
end


function U.createTestCompletedPlants()
 
 local tempTable = {}
 table.insert(tempTable, {
      
      id = 1,
      plantType = "noun",
      cropNum = 1,
      plantStage = 1,
      score = 2
      
  })
tempTable[#tempTable].word, tempTable[#tempTable].altWord =  W.getWord("noun", 1, true)

table.insert(tempTable, {
      
      id = 2,
      plantType = "noun",
      cropNum = 1,
      plantStage = 1,
      score = 2
      
  })
tempTable[#tempTable].word, tempTable[#tempTable].altWord =  W.getWord("noun", 1, true)

table.insert(tempTable, {
      
      id = 3,
      plantType = "noun",
      cropNum = 1,
      plantStage = 1,
      score = 2
      
  })
tempTable[#tempTable].word, tempTable[#tempTable].altWord =  W.getWord("noun", 1, true)

table.insert(tempTable, {
      
      id = 4,
      plantType = "noun",
      cropNum = 1,
      plantStage = 1,
      score = 2
      
  })
tempTable[#tempTable].word, tempTable[#tempTable].altWord =  W.getWord("noun", 1, true)

table.insert(tempTable, {
      
      id = 5,
      plantType = "noun",
      cropNum = 1,
      plantStage = 1,
      score = 2
      
  })
tempTable[#tempTable].word, tempTable[#tempTable].altWord =  W.getWord("noun", 1, true)

table.insert(tempTable, {
      
      id = 6,
      plantType = "noun",
      cropNum = 1,
      plantStage = 1,
      score = 2
      
  })
tempTable[#tempTable].word, tempTable[#tempTable].altWord =  W.getWord("noun", 1, true)

table.insert(tempTable, {
      
      id = 7,
      plantType = "ad",
      cropNum = 2,
      plantStage = 1,
      score = 2
      
  })
tempTable[#tempTable].word, tempTable[#tempTable].altWord =  W.getWord("ad", 1, true)

table.insert(tempTable, {
      
      id = 8,
      plantType = "ad",
      cropNum = 2,
      plantStage = 1,
      word = W.getWord("ad", 1, true),
      score = 2
      
  })
tempTable[#tempTable].word, tempTable[#tempTable].altWord =  W.getWord("ad", 1, true)

table.insert(tempTable, {
      
      id = 9,
      plantType = "ad",
      cropNum = 2,
      plantStage = 1,
      word = W.getWord("ad", 1, true),
      score = 2
      
  })
tempTable[#tempTable].word, tempTable[#tempTable].altWord =  W.getWord("ad", 1, true)

table.insert(tempTable, {
      
      id = 10,
      plantType = "ad",
      cropNum = 2,
      plantStage = 1,
      word = W.getWord("ad", 1, true),
      score = 2
      
  })
tempTable[#tempTable].word, tempTable[#tempTable].altWord =  W.getWord("ad", 1, true)

table.insert(tempTable, {
      
      id = 11,
      plantType = "ad",
      cropNum = 2,
      plantStage = 1,
      word = W.getWord("ad", 1, true),
      score = 2
      
  })
tempTable[#tempTable].word, tempTable[#tempTable].altWord =  W.getWord("ad", 1, true)

table.insert(tempTable, {
      
      id = 12,
      plantType = "ad",
      cropNum = 2,
      plantStage = 1,
      word = W.getWord("ad", 1, true),
      score = 2
      
  })
tempTable[#tempTable].word, tempTable[#tempTable].altWord =  W.getWord("ad", 1, true)

table.insert(tempTable, {
      
      id = 13,
      plantType = "ad",
      cropNum = 2,
      plantStage = 1,
      word = W.getWord("ad", 1, true),
      score = 2
      
  })
tempTable[#tempTable].word, tempTable[#tempTable].altWord =  W.getWord("ad", 1, true)

table.insert(tempTable, {
      
      id = 14,
      plantType = "verb",
      cropNum = 3,
      plantStage = 1,
      score = 2
      
  })
tempTable[#tempTable].word, tempTable[#tempTable].altWord =  W.getWord("verb", 1, true)

table.insert(tempTable, {
      
      id = 15,
      plantType = "verb",
      cropNum = 3,
      plantStage = 1,
      word = W.getWord("verb", 1, true),
      score = 2
      
  })
tempTable[#tempTable].word, tempTable[#tempTable].altWord =  W.getWord("verb", 1, true)

table.insert(tempTable, {
      
      id = 16,
      plantType = "verb",
      cropNum = 3,
      plantStage = 1,
      word = W.getWord("verb", 1, true),
      score = 2
      
  })
tempTable[#tempTable].word, tempTable[#tempTable].altWord =  W.getWord("verb", 1, true)

table.insert(tempTable, {
      
      id = 17,
      plantType = "verb",
      cropNum = 3,
      plantStage = 1,
      word = W.getWord("verb", 1, true),
      score = 2
      
  })
tempTable[#tempTable].word, tempTable[#tempTable].altWord =  W.getWord("verb", 1, true)

table.insert(tempTable, {
      
      id = 18,
      plantType = "verb",
      cropNum = 3,
      plantStage = 1,
      word = W.getWord("verb", 1, true),
      score = 2
      
  })
tempTable[#tempTable].word, tempTable[#tempTable].altWord =  W.getWord("verb", 1, true)

return tempTable
 
end

return U