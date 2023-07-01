fp = fopen("C:\Ring\ReadMe.txt","r")
r = ""
while isstring(r)
      r = fgetc(fp)
      if r = char(10) see nl
      else see r ok
end
fclose(fp)
