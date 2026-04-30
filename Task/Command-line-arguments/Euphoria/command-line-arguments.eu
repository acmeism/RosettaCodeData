constant cmd = command_line()
printf(1,"Interpreter/executable name: %s\n",{cmd[1]})
printf(1,"Program file name: %s\n",{cmd[2]})
if length(cmd)>2 then
  puts(1,"Command line arguments:\n")
  for i = 3 to length(cmd) do
    printf(1,"#%d : %s\n",{i,cmd[i]})
  end for
end if
