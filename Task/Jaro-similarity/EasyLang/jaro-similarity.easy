func jarodistance s1$ s2$ .
   s1$[] = strchars s1$
   s2$[] = strchars s2$
   matchstd = higher len s1$[] len s2$[] / 2 - 1
   for i1 to len s1$[]
      for i2 to len s2$[]
         if s1$[i1] = s2$[i2]
            if abs (i2 - i1) <= matchstd
               m += 1
               if i2 = i1
                  p += 1
               .
            .
         .
      .
   .
   t = (m - p) / 2
   return 1 / 3 * (m / len s1$[] + m / len s2$[] + (m - t) / m)
.
print jarodistance "MARTHA" "MARHTA"
print jarodistance "DIXON" "DICKSONX"
print jarodistance "JELLYFISH" "SMELLYFISH"
