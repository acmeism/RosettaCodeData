func Test a,b
   see "a+b" + ( a + b ) + nl
   see "a-b" + ( a - b ) + nl
   see "a*b" + ( a * b ) + nl
   // The quotient isn't integer, so we use the Ceil() function, which truncates it downward.
   see "a/b" + Ceil( a / b ) + nl
   // Remainder:
   see "a%b" + ( a % b ) + nl
   see "a**b" +  pow(a,b )  + nl
