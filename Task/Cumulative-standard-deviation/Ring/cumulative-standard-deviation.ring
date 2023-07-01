# Project : Cumulative standard deviation

decimals(6)
sdsave = list(100)
sd = "2,4,4,4,5,5,7,9"
sumval = 0
sumsqs = 0

for num = 1 to 8
     sd = substr(sd, ",", "")
     stddata = number(sd[num])
     sumval = sumval + stddata
     sumsqs = sumsqs + pow(stddata,2)
     standdev = pow(((sumsqs / num) - pow((sumval /num),2)),0.5)
     sdsave[num] = string(num) + " " + string(sumval) +" " + string(sumsqs)
     see "" + num + " value in = " + stddata + " Stand Dev = " + standdev + nl
next
