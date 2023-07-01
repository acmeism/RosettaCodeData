# Project  : Kernighans large earthquake problem

load "stdlib.ring"
nr = 0
equake = list(3)
fn = "equake.txt"
fp = fopen(fn,"r")

while not feof(fp)
         nr = nr + 1
         equake[nr] = readline(fp)
end
fclose(fp)
for n = 1 to len(equake)
     for m = 1 to len(equake[n])
          if equake[n][m] = " "
             sp = m
          ok
     next
     sptemp = right(equake[n],len(equake[n])-sp)
     sptemo = number(sptemp)
     if sptemp > 6
        see equake[n] + nl
     ok
next
