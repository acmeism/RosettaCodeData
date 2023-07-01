arabic = [1000, 900, 500, 400, 100, 90, 50,  40,  10,  9,  5,   4,  1]
roman  = ["M", "CM", "D", "CD", "C" ,"XC", "L", "XL" ,"X", "IX", "V", "IV", "I"]

see "2009 = " + toRoman(2009) + nl
see "1666 = " + toRoman(1666) + nl
see "3888 = " + toRoman(3888) + nl

func toRoman val
     result = ""
     for i = 1 to 13
         while val >= arabic[i]
               result = result + roman[i]
               val = val - arabic[i]
         end
      next
      return result
