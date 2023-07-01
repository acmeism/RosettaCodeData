# Project : CSV data manipulation

load "stdlib.ring"
fnin = "input.csv"
fnout = "output.csv"
fpin = fopen(fnin,"r")
fpout = fopen(fnout,"r")
csv = read(fnin)
nr = 0
csvstr = ""

while not feof(fpin)
        sum = 0
        nr = nr + 1
        line = readline(fpin)
        if nr = 1
           line = substr(line,nl,"")
           line = line + ",SUM"
           csvstr = csvstr + line + windowsnl()
        else
           csvarr = split(line,",")
           for n = 1 to len(csvarr)
                sum = sum + csvarr[n]
           next
           line = substr(line,nl,"")
           line = line + "," + string(sum)
           csvstr = csvstr + line + windowsnl()
        ok
end
write(fnout,csvstr)
csvend = read(fnout)
fclose(fpin)
fclose(fpout)
see csvend + nl
