print("Normal \027[1mBold\027[0m \027[4mUnderline\027[0m \027[7mInverse\027[0m")
colors = { 30,31,32,33,34,35,36,37,90,91,92,93,94,95,96,97 }
for _,bg in ipairs(colors) do
  for _,fg in ipairs(colors) do
    io.write("\027["..fg..";"..(bg+10).."mX")
  end
  print("\027[0m") -- be nice, reset
end
