t, n = {}, 0
for y=1,31 do t[y]={} for x=1,31 do t[y][x]="  " end end
repeat
  x, y = math.random(-15,15), math.random(-15,15)
  rsq = x*x + y*y
  if rsq>=100 and rsq<=225 and t[y+16][x+16]=="  " then
    t[y+16][x+16], n = "██", n+1
  end
until n==100
for y=1,31 do print(table.concat(t[y])) end
