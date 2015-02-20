! save this program as file f.f08
! gnu-linux command to  build and test
! $ a=./f && gfortran -Wall -std=f2008 $a.f08 -o $a && echo -e 2\\n5\\n\\n | $a

! -*- mode: compilation; default-directory: "/tmp/" -*-
! Compilation started at Fri Apr  4 23:20:27
!
! a=./f && gfortran -Wall -std=f2008 $a.f08 -o $a && echo -e 2\\n8\\ny\\n | $a
! Enter the number of terms to sum: Show the the first how many terms of the sequence?   Accept this initial sequence (y/n)?
!            1           1
!            1           1           2           3           5           8          13          21
!
! Compilation finished at Fri Apr  4 23:20:27

program f
  implicit none
  integer :: n, terms
  integer, allocatable, dimension(:) :: sequence
  integer :: i
  character :: answer
  write(6,'(a)',advance='no')'Enter the number of terms to sum: '
  read(5,*) n
  if ((n < 2) .or. (29 < n)) stop'Unreasonable!  Exit.'
  write(6,'(a)',advance='no')'Show the the first how many terms of the sequence?  '
  read(5,*) terms
  if (terms < 1) stop'Lazy programmer has not implemented backward sequences.'
  n = min(n, terms)
  allocate(sequence(1:terms))
  sequence(1) = 1
  do i = 0, n - 2
     sequence(i+2) = 2**i
  end do
  write(6,*)'Accept this initial sequence (y/n)?'
  write(6,*) sequence(:n)
  read(5,*) answer
  if (answer .eq. 'n') then
     write(6,*) 'Fine.  Enter the initial terms.'
     do i=1, n
        write(6, '(i2,a2)', advance = 'no') i, ': '
        read(5, *) sequence(i)
     end do
  end if
  call nacci(n, sequence)
  write(6,*) sequence(:terms)
  deallocate(sequence)

contains

    subroutine nacci(n, s)
      ! nacci =:  (] , +/@{.)^:(-@#@]`(-#)`])
      integer, intent(in) :: n
      integer, intent(inout), dimension(:) :: s
      integer :: i, terms
      terms = size(s)
!      do i = n+1, terms
 !        s(i) = sum(s(i-n:i-1))
  !    end do
      i = n+1
      if (n+1 .le. terms) s(i) = sum(s(i-n:i-1))
      do i = n + 2, terms
         s(i) = 2*s(i-1) - s(i-(n+1))
      end do
    end subroutine nacci
end program f
