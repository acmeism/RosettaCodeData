: magicSquare(n)
| i j wd |
   n sq log asInteger 1+ ->wd
   n loop: i [
      n loop: j [
         i j + 1- n 2 / + n mod n *
         i j + j + 2 - n mod 1 + +
         System.Out swap <<w(wd) " " << drop
         ]
      printcr
      ]
   System.Out "Magic constant is : " << n sq 1 + 2 / n * << cr ;
