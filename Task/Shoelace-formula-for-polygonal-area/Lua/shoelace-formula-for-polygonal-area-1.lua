function shoeArea(ps)
  local function det2(i,j)
    return ps[i][1]*ps[j][2]-ps[j][1]*ps[i][2]
  end
  local sum = #ps>2 and det2(#ps,1) or 0
  for i=1,#ps-1 do sum = sum + det2(i,i+1)end
  return math.abs(0.5 * sum)
end
