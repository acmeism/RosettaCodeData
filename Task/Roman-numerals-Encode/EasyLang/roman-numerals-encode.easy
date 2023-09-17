func$ dec2rom dec .
   values[] = [ 1000 900 500 400 100 90 50 40 10 9 5 4 1 ]
   symbol$[] = [ "M" "CM" "D" "CD" "C" "XC" "L" "XL" "X" "IX" "V" "IV" "I" ]
   for i = 1 to len values[]
      while dec >= values[i]
         rom$ &= symbol$[i]
         dec -= values[i]
      .
   .
   return rom$
.
print dec2rom 1990
print dec2rom 2008
print dec2rom 1666
