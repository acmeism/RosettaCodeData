function bottles(i)
  local s = i == 1 and "1 bottle of beer" or
            i == 0 and "no more bottles of beer" or
            tostring(i) .. " bottles of beer"
  return s, s
end

for i = 99, 1, -1 do
  print( string.format("%s on the wall,\n%s,\ntake one down, pass it around,", bottles(i)),
         string.format("\n%s on the wall.\n", bottles(i-1)) )
end
