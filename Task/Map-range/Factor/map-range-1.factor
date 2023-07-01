USE: locals
:: map-range ( a1 a2 b1 b2 x -- y )
   x a1 - b2 b1 - * a2 a1 - / b1 + ;
