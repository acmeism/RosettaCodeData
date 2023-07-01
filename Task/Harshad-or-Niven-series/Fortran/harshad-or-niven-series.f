!-*- mode: compilation; default-directory: "/tmp/" -*-
!Compilation started at Tue May 21 13:15:59
!
!a=./f && make $a && $a < unixdict.txt
!gfortran -std=f2003 -Wall -ffree-form f.f03 -o f
!    1    2    3    4    5    6    7    8    9   10   12   18   20   21   24   27   30   36   40   42 1002
!
!Compilation finished at Tue May 21 13:15:59

program Harshad
  integer :: i, h = 0
  do i=1, 20
    call nextHarshad(h)
    write(6, '(i5)', advance='no') h
  enddo
  h = 1000
  call nextHarshad(h)
  write(6, '(i5)') h

contains

  subroutine nextHarshad(h) ! alter input integer h to be the next greater Harshad number.
    integer, intent(inout) :: h
    h = h+1 ! bigger
    do while (.not. isHarshad(h))
      h = h+1
    end do
  end subroutine nextHarshad

  logical function isHarshad(a)
    integer, intent(in) :: a
    integer :: mutable, digit_sum
    isHarshad = .false.
    if (a .lt. 1) return ! false if a < 1
    mutable = a
    digit_sum = 0
    do while (mutable /= 0)
      digit_sum = digit_sum + mod(mutable, 10)
      mutable = mutable / 10
    end do
    isHarshad = 0 .eq. mod(a, digit_sum)
  end function isHarshad

end program Harshad
