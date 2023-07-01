   Doc=: conjunction def 'u :: (n"_)'

   brazilian=: (1 e. (#@~.@(#.^:_1&>)~ (2 + [: (i.) _3&+)))&> Doc 'brazilian y  NB. is 1 if y is brazilian, else 0'

   Filter=: (#~`)(`:6)


   B=: brazilian Filter 4 + i. 300   NB. gather Brazilion numbers less than 304

   20 {. B   NB. first 20 Brazilion numbers
7 8 10 12 13 14 15 16 18 20 21 22 24 26 27 28 30 31 32 33

   odd =: 1 = 2&|

   20 {. odd Filter B   NB. first 20 odd Brazilion numbers
7 13 15 21 27 31 33 35 39 43 45 51 55 57 63 65 69 73 75 77

   prime=: 1&p:

   20 {. prime Filter B   NB. uh oh need a new technique
7 13 31 43 73 127 157 211 241 0 0 0 0 0 0 0 0 0 0 0

   NB. p: y   is the yth prime, with 2 being prime 0
   20 {. brazilian Filter p: 2 + i. 500
7 13 31 43 73 127 157 211 241 307 421 463 601 757 1093 1123 1483 1723 2551 2801
