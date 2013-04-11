subjectPolygon = {
  {50, 150}, {200, 50}, {350, 150}, {350, 300},
  {250, 300}, {200, 250}, {150, 350}, {100, 250}, {100, 200}
}

clipPolygon = {{100, 100}, {300, 100}, {300, 300}, {100, 300}}

function inside(p, cp1, cp2)
  return (cp2.x-cp1.x)*(p.y-cp1.y) > (cp2.y-cp1.y)*(p.x-cp1.x)
end

function intersection(cp1, cp2, s, e)
  local dcx, dcy = cp1.x-cp2.x, cp1.y-cp2.y
  local dpx, dpy = s.x-e.x, s.y-e.y
  local n1 = cp1.x*cp2.y - cp1.y*cp2.x
  local n2 = s.x*e.y - s.y*e.x
  local n3 = 1 / (dcx*dpy - dcy*dpx)
  local x = (n1*dpx - n2*dcx) * n3
  local y = (n1*dpy - n2*dcy) * n3
  return {x=x, y=y}
end

function clip(subjectPolygon, clipPolygon)
  local outputList = subjectPolygon
  local cp1 = clipPolygon[#clipPolygon]
  for _, cp2 in ipairs(clipPolygon) do  -- WP clipEdge is cp1,cp2 here
    local inputList = outputList
    outputList = {}
    local s = inputList[#inputList]
    for _, e in ipairs(inputList) do
      if inside(e, cp1, cp2) then
        if not inside(s, cp1, cp2) then
          outputList[#outputList+1] = intersection(cp1, cp2, s, e)
        end
        outputList[#outputList+1] = e
      elseif inside(s, cp1, cp2) then
        outputList[#outputList+1] = intersection(cp1, cp2, s, e)
      end
      s = e
    end
    cp1 = cp2
  end
  return outputList
end

function main()
  local function mkpoints(t)
    for i, p in ipairs(t) do
      p.x, p.y = p[1], p[2]
    end
  end
  mkpoints(subjectPolygon)
  mkpoints(clipPolygon)

  local outputList = clip(subjectPolygon, clipPolygon)

  for _, p in ipairs(outputList) do
    print(('{%f, %f},'):format(p.x, p.y))
  end
end

main()
