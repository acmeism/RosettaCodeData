# Project : Jensen's Device
# Date    : 2018/01/31
# Author : Gal Zsolt [~ CalmoSoft ~]
# Email   : <calmosoft@gmail.com>

decimals(14)
i = 100
see sum(i,1,100,"1/n") + nl

func sum(i,lo,hi,term)
        temp = 0
        for n = lo to hi step 1
             eval("num = " + term)
             temp = temp + num
        next
        return temp
