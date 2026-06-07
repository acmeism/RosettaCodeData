!
! General FizzBuzz
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., June 2026
!
program GeneralFizzBuzz
implicit none

integer, parameter :: maxNumber = 20    ! Assume this is the maximum, supplied by user
integer, parameter :: maxLen = 4        ! Maximum length of words to print, such as fizz, buzz
integer, parameter :: maxNumFactors = 3 ! Maximum number of factors, Problem Description requires 3.

type Pair                               ! This is the structure of 1 input data set
  integer :: num                        ! The factor, and...
  character (len=maxLen) :: txt         ! ...the text to be written if a number is a multiple of this factor
end type Pair

! the actual input: 3 factors with 3 texts
type (Pair), dimension(maxNumFactors) :: inputPairs =[Pair(3, 'Fizz'),Pair(5, 'Buzz'),Pair(7, 'Baxx')]

! Solve this microproblem
call genFizzBuzz (maxNumber, maxNumFactors, inputPairs)

contains

subroutine genFizzBuzz (nums, facts, pairs)
integer, intent(in) :: nums, facts
type(Pair), intent(in), dimension(facts) :: pairs

integer :: ii, jj
logical :: PrintNumberOnly

do ii=1, nums                                     ! Iterate all test cases
  PrintNumberOnly = .true.                        ! Assume we need to print only the number, not Fizz or the like
  do jj=1, facts                                  ! Iterate the factors
    if (mod (ii, pairs(jj)%num) .eq. 0) then      ! Factor divides ii without remainder : print respective word
      write (*, '(A)', advance='no') pairs(jj)%txt (: len_trim(pairs(jj)%txt))
      PrintNumberOnly = .false.
    end if
  enddo
  if (PrintNumberOnly) then                       ! If no Fizz,buzz or anything has been printed,
    write (*,'(i0)') ii                           !    print just the number
  else                                            ! Otherwise,
    write (*,*)                                   !    terminate current line without additional output
  end if
end do

end subroutine genFizzBuzz

end program GeneralFizzBuzz
