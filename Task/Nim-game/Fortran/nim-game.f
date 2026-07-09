program nim
	implicit none

	integer :: ierr, computer, player, tokens

	tokens = 12

	write (*, *) 'Nim game'
	write (*, *)

	do while (tokens.gt.0)
		write (*, '(A, I0)') 'Tokens remaining: ', tokens
		write (*, '(A)', advance = 'no') 'How much tokens do you want to take? '
		read (*, *, iostat = ierr) player

		if (ierr.ne.0) then
			write (*, *) 'Input is not a number!'
			write (*, *)
			cycle
		end if

		if ((player.gt.3).or.(player.lt.1)) then
			write (*, *) 'You can''t take that many tokens!'
			write (*, *)
		else
			computer = min(4, tokens) - player
			tokens = tokens - (computer + player)

			if (computer.eq.1) then
				write (*, '(A, I0, A)') 'Computer takes ', computer, ' token.'
				write (*, *)
			else
				write (*, '(A, I0, A)') 'Computer takes ', computer, ' tokens.'
				write (*, *)
			end if
		end if
	end do

	write (*, *) 'Computer wins!'
end program nim
