import: console

: testInput{
| s n |
   System.Console askln ->s
   while (System.Console askln asInteger dup ->n isNull) [ "Not an integer" println ]

   System.Out "Received : " << s << " and " << n << cr ;
