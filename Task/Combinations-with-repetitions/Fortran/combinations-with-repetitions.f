program main
	integer :: chosen(4)
	integer :: ssize
	
	character(len=50) :: donuts(4) = [ "iced", "jam", "plain", "something completely different" ]
	
	ssize = choose( chosen, 2, 3 )
	write(*,*) "Total = ", ssize
	
	contains
	
	recursive function choose( got, len, maxTypes, nChosen, at ) result ( output )
		integer :: got(:)
		integer :: len
		integer :: maxTypes
		integer :: output
		integer, optional :: nChosen
		integer, optional :: at
		
		integer :: effNChosen
		integer :: effAt
		
		integer :: i
		integer :: counter
		
		effNChosen = 1
		if( present(nChosen) ) effNChosen = nChosen
		
		effAt = 1
		if( present(at) ) effAt = at
		
		if ( effNChosen == len+1 ) then
			do i=1,len
				write(*,"(A10,5X)", advance='no') donuts( got(i)+1 )
			end do
			
			write(*,*) ""
			
			output = 1
			return
		end if
		
		counter = 0
		do i=effAt,maxTypes
			got(effNChosen) = i-1
			counter = counter + choose( got, len, maxTypes, effNChosen + 1, i )
		end do
		
		output = counter
		return
	end function choose

end program main
