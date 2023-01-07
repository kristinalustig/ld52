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

return U