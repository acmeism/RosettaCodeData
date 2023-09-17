func rom2dec rom$ .
   symbols$[] = [ "M" "D" "C" "L" "X" "V" "I" ]
   values[] = [ 1000 500 100 50 10 5 1 ]
   val = 0
   for dig$ in strchars rom$
      for i = 1 to len symbols$[]
         if symbols$[i] = dig$
            v = values[i]
         .
      .
      val += v
      if oldv < v
         val -= 2 * oldv
      .
      oldv = v
   .
   return val
.
print rom2dec "MCMXC"
print rom2dec "MMVIII"
print rom2dec "MDCLXVI"
