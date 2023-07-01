 : dig.num                                       \ returns input number and the number of its digits ( n -- n n1 )
	 dup
	 0 swap
     begin
	 swap 1 + swap
	 dup 10 >= while
	 10 /
     repeat
	 drop ;
	
 : to.self                                        \ returns input number raised to the power of itself ( n -- n^n  )
	 dup 1 = if drop 1 else                   \ positive numbers only, zero and negative returns zero
	 dup 0 <= if drop 0 else
	 dup
         1 do
	 dup
	 loop
	 dup
	 1 do
	 *
         loop
	 then then ;

 : ten.to			                    \ ( n -- 10^n ) returns 1 for zero and negative
	 dup 0 <= if drop 1 else
	 dup 1 = if drop 10 else
	 10 swap
         1 do
	 10 *
         loop then then ;
	
 : zero.divmod                                       \ /mod that returns zero if number is zero
	  dup
	  0 = if drop 0
          else /mod
	  then ;
	
 : split.div                                         \ returns input number and its digits ( n -- n n1 n2 n3....)
	  dup 10 < if dup 0 else		     \ duplicates single digit numbers adds 0 for add.pow
	  dig.num			             \ provides number of digits
	  swap dup rot dup 1 - ten.to swap           \ stack juggling, ten raised to number of digits - 1...
          1 do                                       \ ... is the needed divisor, counter on top and ...
	  dup rot swap zero.divmod swap rot 10 /     \ ...division loop
          loop drop then ;
	
 : add.pow	  				     \ raises each number on the stack except last one to ...
	  to.self                                    \ ...the power of itself and adds them
	  depth					     \ needs at least 3 numbers on the stack
          2 do
	  swap to.self +
          loop ;

 : check.num
	 split.div add.pow ;
	
 : munch.num                                         \ ( n -- ) displays Munchausen numbers between 1 and n
         1 +
	 page
         1 do
         i check.num = if i . cr
         then loop ;
