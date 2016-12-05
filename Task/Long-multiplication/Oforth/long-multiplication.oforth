Number Class new: Natural(v)

Natural method: initialize  := v ;
Natural method: _v  @v ;

Natural classMethod: newValues super new ;
Natural classMethod: newFrom   asList self newValues ;

Natural method: *(n)
| v i j l x k |
   n _v ->v
   ListBuffer initValue(@v size v size + 1+, 0) ->l

   v size loop: i [
      i v at dup ->x 0 ifEq: [ continue ]
      0 @v size loop: j [
         i j + 1- ->k
         j @v at x * + l at(k) + 1000000000 /mod k rot l put
         ]
      k 1+ swap l put
      ]
   while(l last 0 == l size 0 <> and) [ l removeLast drop ]
   l dup freeze Natural newValues ;

Natural method: <<
| i |
   @v last <<
   @v size 1 - loop: i [ @v at(@v size i -) <<wjp(0, JUSTIFY_RIGHT, 8) ] ;
