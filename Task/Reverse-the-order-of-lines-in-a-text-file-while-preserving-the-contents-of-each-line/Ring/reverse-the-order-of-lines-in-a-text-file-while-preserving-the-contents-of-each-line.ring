load "stdlib.ring"
see "working..." + nl
see "Input file lines:" + nl

fp = fopen("..\New\text.txt","r")
r = ""
txt = ""
while isstring(r)
      r = fgetc(fp)
      if r = -1
         loop
      ok
      if r = char(10)
         txt += nl
      else
         txt += r
      ok
end

see txt + nl
see "Reversed file lines: " + nl
txt = str2list(txt)
txt = reverse(txt)
txt = list2str(txt)
see txt
fclose(fp)

see nl + "done..." + nl
