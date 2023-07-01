local bitmap = Bitmap(11,5)
bitmap:clear({255,255,255})
for y = 1, 5 do
  for x = 1, 11 do
    if x==1 or x==5 or x==7 or (y>1 and (x==9 or x==11)) or (y==5 and x~=4 and x~=8 and x~=10) or (x==10 and (y==1 or y==3)) then
      bitmap:set(x-1, y-1, {0,0,0}) -- creates "LUA" with 3x5 font
    end
  end
end
bitmap:savePPM("lua3x5.ppm")
