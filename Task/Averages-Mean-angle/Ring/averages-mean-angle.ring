# Project : Averages/Mean angle

load "stdlib.ring"
decimals(6)
pi = 3.1415926535897
angles = [350,10]
see meanangle(angles, len(angles)) + nl
angles = [90,180,270,360]
see meanangle(angles, len(angles)) + nl
angles = [10,20,30]
see meanangle(angles, len(angles)) + nl

func meanangle(angles, n)
        sumsin = 0
        sumcos = 0
        for i = 1 to n
             sumsin = sumsin + sin(angles[i]*pi/180)
             sumcos = sumcos + cos(angles[i]*pi/180)
        next
        return 180/pi*atan3(sumsin, sumcos)

func atan3(y,x)
        if x <= 0
           return sign(y)*pi/2
        ok
        if x>0
           return atan(y/x)
        else
           if y>0
              return atan(y/x)+pi
           else
              return atan(y/x)-pi
           ok
        ok
