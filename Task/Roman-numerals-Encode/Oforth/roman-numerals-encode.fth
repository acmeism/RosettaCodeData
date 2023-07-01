[ [1000,"M"], [900,"CM"], [500,"D"], [400,"CD"], [100,"C"], [90,"XC"], [50,"L"], [40,"XL"], [10,"X"], [9,"IX"], [5,"V"], [4,"IV"], [1,"I"] ] const: Romans

: roman(n)
| r |
   StringBuffer new
   Romans forEach: r [ while(r first n <=) [ r second << n r first - ->n ] ] ;
