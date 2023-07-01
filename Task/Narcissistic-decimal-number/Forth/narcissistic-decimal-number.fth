 : dig.num                           \ returns input number and the number of its digits ( n -- n n1 )
	 dup
	 0 swap
     begin
	 swap 1 + swap
	 dup 10 >= while
	 10 /
     repeat
	 drop ;

 : zero.divmod                         \ /mod that returns zero if number is zero
	   dup
	   0 = if drop 0 else
           /mod
	   then ;
	
 : zero.div                            \ division that returns zero if divisor is zero
	 dup
	 0 = if drop else
         /
	 then ;

 : next.last
	 depth 2 - roll ;                 \ gets next-to-last number from the stack

 : ten.to			          \ ( n -- 10^n ) returns 1 for zero and negative
	  dup 0 <= if drop 1 else
	  dup 1 = if drop 10 else
	  10 swap
	  1 do
	  10 *
	  loop then then ;

 : split.div                                        \ returns input number and its digits ( n -- n n1 n2 n3....)
	   dup 10 < if dup  else		    \ duplicates single digit numbers
	   dig.num				    \ provides number of digits
	   swap dup rot dup 1 - ten.to swap         \ stack juggling, ten raised to number of digits - 1...
	   1 do                                     \ ... is the needed divisor, counter on top and ...
	   dup rot swap zero.divmod swap rot 10 /   \ ...division loop
	   loop drop then ;

 : to.pow                           \ nth power of positive numbers ( n m -- n^m )
	 swap dup rot
	 dup 0 <= if
	 2drop drop 1
	 else
	 0 do
	 swap dup rot *
	 loop
	 swap zero.div
	 then ;
	
 : num.pow                        \ raises each digit to the power of (number of digits)
	 depth 1 - 0 do
	 next.last depth 1 - to.pow
	 loop ;
	
 : add.num
	 depth 2 > if
	 begin
	 +
	 depth 2 = until then ;
	
 : narc.check
	split.div
        num.pow
        add.num ;
	
 : narc.num 0 { a b }              \  ( m -- n1 n2 n3 ... nm )
	 page                      \ displays m narcissistic decimal numbers...
	 999999999 0 do            \ ...beginning with 0
	 a b = if leave then
	 i narc.check = if
	 i . cr b 1 + to b
	 then
	 loop
	 ;
	
 25 narc.num
