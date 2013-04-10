program main

 implicit none

 character(len=7),dimension(10) :: haystack = [  &
  'Zig    ',&
  'Zag    ',&
  'Wally  ',&
  'Ronald ',&
  'Bush   ',&
  'Krusty ',&
  'Charlie',&
  'Bush   ',&
  'Boz    ',&
  'Zag    ']

 call find_needle('Charlie')
 call find_needle('Bush')

 contains

	subroutine find_needle(needle)
	implicit none
	character(len=*),intent(in) :: needle
	integer :: i
	do i=1,size(haystack)
		if (needle==haystack(i)) then
			write(*,'(A,I4)') trim(needle)//' found at index:',i
			return
		end if
	end do
	write(*,'(A)') 'Error: '//trim(needle)//' not found.'
	end subroutine find_needle

 end program main
