!-*- mode: compilation; default-directory: "/tmp/" -*-
!Compilation started at Sat Jun  1 14:48:41
!
!a=./f && make $a && OMP_NUM_THREADS=2 $a < unixdict.txt # some of the compilation options and redirection from unixdict.txt are vestigial.
!gfortran -std=f2008 -Wall -fopenmp -ffree-form -fall-intrinsics -fimplicit-none f.f08 -o f
!                 123  123
!               12345  234
!             1234567  345
!           987654321  654
!               10001  000
!              -10001  000
!                -123  123
!                -100  100
!                 100  100
!              -12345  234
!                   1  Too short
!                   2  Too short
!                  -1  Too short
!                 -10  Too short
!                2002  Digit count too even
!               -2002  Digit count too even
!                   0  Too short
!
!Compilation finished at Sat Jun  1 14:48:41


program MiddleMuddle
  integer, dimension(17) :: itest, idigits
  integer :: i, n
  data itest/123,12345,1234567,987654321,10001,-10001,-123,-100,100,-12345,1,2,-1,-10,2002,-2002,0/
  do i = 1, size(itest)
    call antibase(10, abs(itest(i)), idigits, n)
    write(6,'(i20,2x,a20)') itest(i), classifym3(idigits, n)
    if (0 .eq. itest(i)) exit
  end do

contains

  logical function even(n)
    integer, intent(in) :: n
    even = 0 .eq. iand(n,1)
  end function even

  function classifym3(iarray, n) result(s)
    integer, dimension(:), intent(in) :: iarray
    integer, intent(in) :: n
    character(len=20) :: s
    integer :: i,m
    if (n < 3) then
      s = 'Too short'
    else if (even(n)) then
      s = 'Digit count too even'
    else
      m = (n+1)/2
      write(s,'(3i1)')(iarray(i), i=m+1,m-1,-1)
    end if
  end function classifym3

  subroutine antibase(base, m, digits, n) ! digits ordered by increasing significance
    integer, intent(in) :: base, m
    integer, intent(out) :: n  ! the number of digits
    integer, dimension(:), intent(out) :: digits
    integer :: em
    em = m
    do n=1, size(digits)
      digits(n) = mod(em, base)
      em = em / base
      if (0 .eq. em) return
    end do
    stop 'antibase ran out of space to store result'
  end subroutine antibase

end program MiddleMuddle
