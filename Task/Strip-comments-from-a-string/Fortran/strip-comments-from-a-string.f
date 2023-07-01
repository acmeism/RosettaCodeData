!****************************************************
 module string_routines
!****************************************************
 implicit none
 private
 public :: strip_comments
 contains
!****************************************************

	 function strip_comments(str,c) result(str2)
	 implicit none
	 character(len=*),intent(in) :: str
	 character(len=1),intent(in) :: c !comment character
	 character(len=len(str)) :: str2
	
	 integer :: i
	
	 i = index(str,c)
	 if (i>0) then
		str2 = str(1:i-1)
	 else
		str2 = str
	 end if
	
	 end function strip_comments

!****************************************************
 end module string_routines
!****************************************************

!****************************************************
 program main
!****************************************************
! Example use of strip_comments function
!****************************************************
 use string_routines, only: strip_comments
 implicit none

 write(*,*) strip_comments('apples, pears # and bananas', '#')
 write(*,*) strip_comments('apples, pears ; and bananas', ';')

!****************************************************
 end program main
!****************************************************
