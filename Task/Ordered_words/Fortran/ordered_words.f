!***************************************************************************************
 module ordered_module
!***************************************************************************************
 implicit none

	!the dictionary file:
	integer,parameter :: file_unit = 1000
	character(len=*),parameter :: filename = 'unixdict.txt'

	!maximum number of characters in a word:
	integer,parameter :: max_chars = 50

	type word
	  character(len=max_chars) :: str    !the word from the dictionary
	  integer	:: n = 0    !length of this word
	  logical	:: ordered = .false.    !if it is an ordered word
	end type word

	!the dictionary structure:
	type(word),dimension(:),allocatable :: dict

	contains
!***************************************************************************************

	!******************************************************************************
		function count_lines_in_file(fid) result(n_lines)
	!******************************************************************************
		implicit none

		integer             :: n_lines
		integer,intent(in)  :: fid		
		character(len=1)    :: tmp
		integer             :: i
		integer             :: ios

		!the file is assumed to be open already.

		rewind(fid)	  !rewind to beginning of the file

		n_lines = 0
		do !read each line until the end of the file.
			read(fid,'(A1)',iostat=ios) tmp
			if (ios < 0) exit      !End of file
			n_lines = n_lines + 1  !row counter
		end do

		rewind(fid)   !rewind to beginning of the file	

	!******************************************************************************
		end function count_lines_in_file
	!******************************************************************************

	!******************************************************************************
	 pure elemental function ordered_word(word) result(yn)
	!******************************************************************************
	! turns true if word is an ordered word, false if it is not.
	!******************************************************************************
	
	 implicit none
	 character(len=*),intent(in) :: word
	 logical :: yn
	
	 integer :: i
	
	 yn = .true.
	 do i=1,len_trim(word)-1
	 	if (ichar(word(i+1:i+1))<ichar(word(i:i))) then
	 		yn = .false.
	 		exit
	 	end if
	 end do
	
	!******************************************************************************
	 end function ordered_word
	!******************************************************************************

!***************************************************************************************
 end module ordered_module
!***************************************************************************************

!****************************************************
 program main
!****************************************************
 use ordered_module
 implicit none

	integer :: i,n,n_max

	!open the dictionary and read in all the words:
	open(unit=file_unit,file=filename)     		!open the file
	n = count_lines_in_file(file_unit)      !count lines in the file
	allocate(dict(n))                       !allocate dictionary structure
	do i=1,n                                !
		read(file_unit,'(A)') dict(i)%str   !each line is a word in the dictionary
		dict(i)%n = len_trim(dict(i)%str)   !save word length
	end do		
	close(file_unit)                        !close the file

	!use elemental procedure to get ordered words:
	dict%ordered = ordered_word(dict%str)	

	!max length of an ordered word:
	n_max = maxval(dict%n, mask=dict%ordered)
		
	!write the output:
	do i=1,n
		if (dict(i)%ordered .and. dict(i)%n==n_max) write(*,'(A,A)',advance='NO') trim(dict(i)%str),' '
	end do
	write(*,*) ''

!****************************************************
 end program main
!****************************************************
