-- arg[1] is the first argument provided at the command line
for line in io.lines(arg[1] or "data.txt") do  -- use data.txt if arg[1] is nil
  magnitude = line:match("%S+$")
  if tonumber(magnitude) > 6 then print(line) end
end
