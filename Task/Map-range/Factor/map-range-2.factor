USING: locals infix ;
:: map-range ( a1 a2 b1 b2 x -- y )
   [infix
     b1 + (x - a1) * (b2 - b1) / (a2 - a1)
   infix] ;
