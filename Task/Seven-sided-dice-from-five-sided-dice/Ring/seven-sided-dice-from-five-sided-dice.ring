# Project : Seven-sided dice from five-sided dice
# Date    : 2018/02/02
# Author : Gal Zsolt [~ CalmoSoft ~]
# Email   : <calmosoft@gmail.com>

for n = 1 to 20
         d = dice7()
         see "" + d + " "
next
see nl

func dice7()
         x = dice5() * 5 + dice5() - 6
         if x > 20
            return dice7()
         ok
         dc = x % 7 + 1
         return dc

func dice5()
        rnd = random(4) + 1
        return rnd
