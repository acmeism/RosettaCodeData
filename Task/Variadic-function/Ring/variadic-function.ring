# Project : Variadic function
# Date    : 2017/11/13
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

sum([1,2])
sum([1,2,3])
nums = [1,2,3,4]
sum(nums)

func sum(nums)
       total = 0
       for num = 1 to len(nums)
           total = total + num
       next
       showarray(nums)
       see " " + total + nl

func showarray(vect)
       see "["
       svect = ""
       for n = 1 to len(vect)
           svect = svect + vect[n] + " "
       next
       svect = left(svect, len(svect) - 1)
       see "" + svect + "]"
