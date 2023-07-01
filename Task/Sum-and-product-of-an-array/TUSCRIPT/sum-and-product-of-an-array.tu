$$ MODE TUSCRIPT
list="1'2'3'4'5"
sum=SUM(list)
PRINT "    sum: ",sum

product=1
LOOP l=list
product=product*l
ENDLOOP
PRINT "product: ",product
