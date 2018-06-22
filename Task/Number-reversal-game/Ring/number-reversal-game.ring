# Project : Number reversal game
# Date    : 2017/12/02
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

rever = 1:9
leftrever = []
for n = 1 to len(rever)
     rnd = random(8) + 1
     temp = rever[n]
     rever[n] = rever[rnd]
     rever[rnd] = temp
next
see rever
see nl
while true
         num = 0
         leftrever = []
         showarray(rever)
         see " : Reverse how many = "
         give r
         r = number(r)
         for n = 1 to r
               add(leftrever, rever[n])
         next
         leftrever = reverse(leftrever)
         for pos = 1 to r
               rever[pos] = leftrever[pos]
         next
         for m = 1 to len(rever)
              if rever[m] = m
                 num = num + 1
              ok
         next
         if num = len(rever)
            exit
         ok
end
see "You took " + num + " attempts." + nl

func swap(a, b)
       temp = a
       a = b
       b = temp
       return [a, b]

func showarray(vect)
       svect = ""
       for n = 1 to len(vect)
             svect = svect + vect[n] + " "
       next
       svect = left(svect, len(svect) - 1)
       see svect
