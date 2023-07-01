 43 constant border                                                         \ grid size is border x border
 border border * constant size

 variable crawler                                                           \ position of the crawler

 : set.crawler border 2 mod 0= if                                           \ positions the crawler in the middle of the grid
	 size 2 / border 2/ + 1 - crawler !
	 else
	 size 2 / crawler ! then ;
	
 set.crawler
 create Grid size cells allot                                               \ creates the grid
 here constant GridEnd                                                      \ used for debugging

 : is.divisor
	over 2over
	mod 0= swap drop + ;

 : sub.one
	 swap 1 - swap ;

 : next.div
	 is.divisor sub.one ;

 : three.test                                                                \ counts divisors for numbers bigger than 2
	 dup 0
     begin
	 next.div
     over 1 = until
	 swap drop
	 swap drop 1 + ;
	
 : not.prime                                                                 \ counts the number of divisors. Primes have exactly two.
    dup
    2 < if drop true else
	three.test then ;

 : sub.four                                                                   \ the crawler takes a number from the stack as direction
	 dup 4 > if 4 - then ;                                                \ this word makes the number roll over.
                                                                              \ 1-right 2-up 3-left 4-down
 : craw.left                                                                  \ rotates the crawler 90 degrees counter-clockwise
	 1 + sub.four ;

 : scan.right
	 grid crawler @ 1 + cells + @ 0= ;                                    \ checks if cell to the right of the crawler is zero

 : scan.left
	 grid crawler @ 1 - cells + @ 0= ;                                    \ cell to the left

 : scan.up
	 grid crawler @ border - cells + @ 0= ;                               \ cell above

 : scan.down
	 grid crawler @ border + cells + @ 0= ;                               \ and cell below

 : crawler.go                                                                 \ moves crawler one cell ahead checks cell to the left...
	 dup                                                                  \ ...of the direction the crawler is facing, if zero, turns
	 1 = if crawler @ 1 + crawler ! scan.up if craw.left then else
	 dup
	 2 = if crawler @ border - crawler ! scan.left if craw.left then else
	 dup
	 3 = if crawler @ 1 - crawler ! scan.down if craw.left then else
	 dup
	 4  = if crawler @ border + crawler ! scan.right if craw.left then else
	
	 then then then then ;
	
 : run.crawler                                                              \ crawler moves through the grid and fills it with numbers
	 border 2 < if 1 grid 0 cells + ! else                              \ if the grid is a single cell, puts 1 in it
	 crawler @ border - crawler !	                                    \ crawler moves one step and turn before setting the first...
	 4                                                                  \ ...number so it is repositioned one cell up facing down
  	 size -1 * 0 do  i
	 i -1 * grid crawler @ cells + ! drop
	 crawler.go
	 -1 +loop then drop ;

 : leave.primes                                                                    \ removes non-primes from the grid
	 size 0 do i
	 grid i cells + @ not.prime if 0 grid i cells + ! then drop
	 loop ;

 : star.draw1                                                                      \ draws a "*" where number is not zero
	 0> if 42 emit else 32 emit
	 then ;

 : star.draw2
	 0> if 42 emit 32 emit else 32 emit 32 emit                                 \ same but adds a space for better presentation
	 then ;

 : star.draw3
	 0> if 32 emit 42 emit 32 emit else 32 emit 32 emit 32 emit                 \ adds two spaces
	 then ;

 : draw.grid                                                                         \ cuts the array into lines and displays it
	page
	size 0 do i
	i border mod 0= if  cr  then
	grid i cells + @ star.draw2 drop                                             \ may use star.draw1 or 3 here
	loop ;
	
 : ulam.spiral run.crawler leave.primes draw.grid ;                                  \ draws the spiral. Execute this word to run.
