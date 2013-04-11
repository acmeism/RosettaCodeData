program guess_the_number
 implicit none

 integer                          :: guess
 real                             :: r
 integer                          :: i, clock, count, n
 integer,dimension(:),allocatable :: seed

 real,parameter :: rmax = 10	

!initialize random number generator:
 call random_seed(size=n)
 allocate(seed(n))
 call system_clock(count)
 seed = count
 call random_seed(put=seed)
 deallocate(seed)

!pick a random number between 1 and rmax:
 call random_number(r)          !r between 0.0 and 1.0
 i = int((rmax-1.0)*r + 1.0)    !i between 1 and rmax

!get user guess:
 write(*,'(A)') 'I''m thinking of a number between 1 and 10.'
 do   !loop until guess is correct
	write(*,'(A)',advance='NO') 'Enter Guess: '
	read(*,'(I5)') guess
	if (guess==i) exit
	write(*,*) 'Sorry, try again.'
 end do

 write(*,*) 'You''ve guessed my number!'

end program guess_the_number
