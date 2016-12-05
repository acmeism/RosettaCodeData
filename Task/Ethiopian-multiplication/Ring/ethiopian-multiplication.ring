x = 17
y = 34
p = 0
while x != 0
      if not even(x)
         p += y
         see "" + x + " " + " " + y + nl
      else
         see "" + x + "  ---" + nl ok
         x = halve(x)
         y = double(y)
end
see " " + "  ===" + nl
see "   " + p

func double n return (n * 2)
func halve n return floor(n / 2)
func even n return ((n & 1) = 0)
