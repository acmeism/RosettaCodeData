!***************************************************************************************
	module anagram_routines
!***************************************************************************************
	implicit none
	
	!the dictionary file:
	integer,parameter :: file_unit = 1000
	character(len=*),parameter :: filename = 'unixdict.txt'
	
	!maximum number of characters in a word:
	integer,parameter :: max_chars = 50
	
	!maximum number of characters in the string displaying the anagram lists:
	integer,parameter :: str_len = 256
	
	type word
	  character(len=max_chars) :: str = repeat(' ',max_chars)    !the word from the dictionary
	  integer                  :: n = 0                          !length of this word
	  integer                  :: n_anagrams = 0	             !number of anagrams found
	  logical                  :: checked = .false.              !if this one has already been checked
	  character(len=str_len)   :: anagrams = repeat(' ',str_len) !the anagram list for this word
	end type word
	
	!the dictionary structure:
	type(word),dimension(:),allocatable,target :: dict
	
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
		pure elemental function is_anagram(x,y)
	!******************************************************************************
		implicit none
		character(len=*),intent(in) :: x
		character(len=*),intent(in) :: y
		logical :: is_anagram
	
		character(len=len(x)) :: x_tmp	!a copy of x
		integer :: i,j
		
		!a character not found in any word:
		character(len=1),parameter :: null = achar(0)
			
		!x and y are assumed to be the same size.
		
		x_tmp = x
		do i=1,len_trim(x)
			j = index(x_tmp, y(i:i)) !look for this character in x_tmp
			if (j/=0) then
				x_tmp(j:j) = null  !clear it so it won't be checked again
			else
				is_anagram = .false. !character not found: x,y are not anagrams
				return
			end if
		end do
	
		!if we got to this point, all the characters
		! were the same, so x,y are anagrams:
		is_anagram = .true.
					
	!******************************************************************************
		end function is_anagram
	!******************************************************************************

!***************************************************************************************
	end module anagram_routines
!***************************************************************************************

!***************************************************************************************
	program main
!***************************************************************************************
	use anagram_routines
	implicit none
	
	integer :: n,i,j,n_max
	type(word),pointer :: x,y
	logical :: first_word
	real :: start, finish
	
	call cpu_time(start)	!..start timer
	
	!open the dictionary and read in all the words:
	open(unit=file_unit,file=filename)      !open the file
	n = count_lines_in_file(file_unit)      !count lines in the file
	allocate(dict(n))                       !allocate dictionary structure
	do i=1,n                                !
		read(file_unit,'(A)') dict(i)%str   !each line is a word in the dictionary
		dict(i)%n = len_trim(dict(i)%str)   !saving length here to avoid trim's below
	end do		
	close(file_unit)                        !close the file
	
	!search dictionary for anagrams:
	do i=1,n
		
		x => dict(i)	!pointer to simplify code
		first_word = .true.	!initialize
		
		do j=i,n
		
			y => dict(j)	!pointer to simplify code
			
			!checks to avoid checking words unnecessarily:
			if (x%checked .or. y%checked) cycle     !both must not have been checked already
			if (x%n/=y%n) cycle                     !must be the same size
			if (x%str(1:x%n)==y%str(1:y%n)) cycle   !can't be the same word
			
			! check to see if x,y are anagrams:
			if (is_anagram(x%str(1:x%n), y%str(1:y%n))) then
				!they are anagrams.
				y%checked = .true. 	!don't check this one again.
				x%n_anagrams = x%n_anagrams + 1
				if (first_word) then
					!this is the first anagram found for this word.
					first_word = .false.
					x%n_anagrams = x%n_anagrams + 1
					x%anagrams = trim(x%anagrams)//x%str(1:x%n)  !add first word to list
				end if
				x%anagrams = trim(x%anagrams)//','//y%str(1:y%n) !add next word to list
			end if
	
		end do
		x%checked = .true.  !don't check this one again
		
	end do
	
	!anagram groups with the most words:
	write(*,*) ''
	n_max = maxval(dict%n_anagrams)
	do i=1,n
		if (dict(i)%n_anagrams==n_max) write(*,'(A)') trim(dict(i)%anagrams)
	end do
	
	!anagram group containing longest words:
	write(*,*) ''
	n_max = maxval(dict%n, mask=dict%n_anagrams>0)
	do i=1,n
		if (dict(i)%n_anagrams>0 .and. dict(i)%n==n_max) write(*,'(A)') trim(dict(i)%anagrams)
	end do
	write(*,*) ''

	call cpu_time(finish)	!...stop timer
	write(*,'(A,F6.3,A)') '[Runtime = ',finish-start,' sec]'
	write(*,*) ''

!***************************************************************************************
	end program main
!***************************************************************************************
