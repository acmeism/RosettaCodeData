fp = fopen("C:\Ring\ReadMe.txt","r")
r = fgetc(fp)
while isstring(r)
      r = fgetc(fp)
      see r
end
fclose(fp)
