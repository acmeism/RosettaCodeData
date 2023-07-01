function ifibs(n)
  local p0,p1=0,1
  for _=1,n do p0,p1 = p1,p0+p1 end
  return p0
end
