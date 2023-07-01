 !***************************************************************************************************
 	module evolve_routines
 !***************************************************************************************************
 	implicit none
 	
 	!the target string:
 	character(len=*),parameter :: targ = 'METHINKS IT IS LIKE A WEASEL'
 	
 	contains
 !***************************************************************************************************
 	
 !********************************************************************
 	pure elemental function fitness(member) result(n)
 !********************************************************************
 ! The fitness function.  The lower the value, the better the match.
 ! It is zero if they are identical.
 !********************************************************************
 	
 	implicit none
 	integer :: n
 	character(len=*),intent(in) :: member
 	
 	integer :: i
 	
 	n=0
 	do i=1,len(targ)
 		n = n + abs( ichar(targ(i:i)) - ichar(member(i:i))  )
 	end do
 	
 !********************************************************************
 	end function fitness
 !********************************************************************
 	
 !********************************************************************
 	pure elemental subroutine mutate(member,factor)
 !********************************************************************
 ! mutate a member of the population.
 !********************************************************************
 	
 	implicit none
 	character(len=*),intent(inout) :: member   !population member
 	real,intent(in) :: factor                  !mutation factor
 	
 	integer,parameter :: n_chars = 27	!number of characters in set
 	character(len=n_chars),parameter :: chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ '
 	
 	real    :: rnd_val
 	integer :: i,j,n
 	
 	n = len(member)
 		
 	do i=1,n
 		rnd_val = rand()
 		if (rnd_val<=factor) then   !mutate this element			
 			rnd_val = rand()
 			j = int(rnd_val*n_chars)+1   !an integer between 1 and n_chars
 			member(i:i) = chars(j:j)
 		end if
 	end do
 	
 !********************************************************************
	end subroutine mutate
 !********************************************************************

 !***************************************************************************************************
 	end module evolve_routines
 !***************************************************************************************************

 !***************************************************************************************************
 	program evolve
 !***************************************************************************************************
 ! The main program
 !***************************************************************************************************
 	use evolve_routines
 	
 	implicit none
 	
 	!Tuning parameters:
 	integer,parameter :: seed = 12345             !random number generator seed
 	integer,parameter :: max_iter = 10000         !maximum number of iterations
 	integer,parameter :: population_size = 200    !size of the population
 	real,parameter    :: factor = 0.04            ![0,1] mutation factor
 	integer,parameter :: iprint = 5               !print every iprint iterations
 	
 	!local variables:
 	integer :: i,iter
 	integer,dimension(1) :: i_best
 	character(len=len(targ)),dimension(population_size) :: population
 	
 	!initialize random number generator:
 	call srand(seed)
 	
 	!create initial population:
 	! [the first element of the population will hold the best member]
 	population(1) = 'PACQXJB CQPWEYKSVDCIOUPKUOJY'  !initial guess
 	iter=0
 		
 	write(*,'(A10,A30,A10)') 'iter','best','fitness'
 	write(*,'(I10,A30,I10)') iter,population(1),fitness(population(1))
 		
 	do
 	
 		iter = iter + 1 !iteration counter
 		
  		!write the iteration:
 		if (mod(iter,iprint)==0) write(*,'(I10,A30,I10)') iter,population(1),fitness(population(1))
		
 		!check exit conditions:
 		if ( iter>max_iter .or. fitness(population(1))==0 ) exit
 	
 		!copy best member and mutate:
 		population = population(1)	
 		do i=2,population_size
 			call mutate(population(i),factor)	
 		end do
 	
 		!select the new best population member:
 		! [the best has the lowest value]
 		i_best = minloc(fitness(population))
 		population(1) = population(i_best(1))
 		 	
 	end do
 	
 	!write the last iteration:
 	if (mod(iter,iprint)/=0) write(*,'(I10,A30,I10)') iter,population(1),fitness(population(1))
 	 	
 	if (iter>max_iter) then
 		write(*,*) 'No solution found.'
 	else
 		write(*,*) 'Solution found.'
 	end if
 	
 !***************************************************************************************************
 	end program evolve
 !***************************************************************************************************
