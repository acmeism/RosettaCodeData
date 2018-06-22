# Project : The Twelve Days of Christmas
# Date    : 2017/11/14
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

gifts = "A partridge in a pear tree,Two turtle doves,Three french hens,Four calling birds,Five golden rings,Six geese a-laying,Seven swans a-swimming,Eight maids a-milking,Nine ladies dancing,Ten lords a-leaping,Eleven pipers piping,Twelve drummers drumming"
days = "first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth"
lstgifts = str2list(substr(gifts,",", nl))
lstdays = str2list(substr(days, " ", nl))
for i = 1 to 12
     see "On the "+ lstdays[i]+ " day of Christmas" + nl
     see "My true love gave to me:" + nl
     for j = i to 1 step -1
          if i > 1 and j = 1
             see "and " + nl
          ok
          see "" + lstgifts[j] + nl
     next
     see nl
next
