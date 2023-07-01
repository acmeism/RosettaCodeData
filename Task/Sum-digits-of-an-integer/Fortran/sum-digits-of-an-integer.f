!-*- mode: compilation; default-directory: "/tmp/" -*-
!Compilation started at Fri Jun  7 21:00:12
!
!a=./f && make $a && $a
!gfortran -std=f2008 -Wall -fopenmp -ffree-form -fall-intrinsics -fimplicit-none f.f08 -o f
!f.f08:57.29:
!
!  subroutine process1(fmt,s,b)
!                             1
!Warning: Unused dummy argument 'b' at (1)
!digit sum       n
!        1 1
!       10 1234
!       29 fe
!       29 f0e
! sum of digits of n expressed in base is...
!      n   base    sum
!      1     10      1
!   1234     10     10
!    254     16     29
!   3854     16     29
!
!Compilation finished at Fri Jun  7 21:00:12

module base_mod
  private :: reverse
contains
  subroutine reverse(a)
    integer, dimension(:), intent(inout) :: a
    integer :: i, j, t
    do i=1,size(a)/2
       j = size(a) - i + 1
       t = a(i)
       a(i) = a(j)
       a(j) = t
    end do
  end subroutine reverse

  function antibase(b, n) result(a)
    integer, intent(in) :: b,n
    integer, dimension(32) :: a
    integer :: m, i
    a = 0
    m = n
    i = 1
    do while (m .ne. 0)
       a(i) = mod(m, b)
       m = m/b
       i = i+1
    end do
    call reverse(a)
  end function antibase
end module base_mod

program digit_sum
  use base_mod
  call still
  call confused
contains
  subroutine still
    character(len=6),parameter :: fmt = '(i9,a)'
    print'(a9,a8)','digit sum','n'
    call process1(fmt,'1',10)
    call process1(fmt,'1234',10)
    call process1(fmt,'fe',16)
    call process1(fmt,'f0e',16)
  end subroutine still

  subroutine process1(fmt,s,b)
    character(len=*), intent(in) :: fmt, s
    integer, intent(in), optional :: b
    integer :: i
    print fmt,sum((/(index('123456789abcdef',s(i:i)),i=1,len(s))/)),' '//s
  end subroutine process1

  subroutine confused
    character(len=5),parameter :: fmt = '(3i7)'
    print*,'sum of digits of n expressed in base is...'
    print'(3a7)','n','base','sum'
    call process0(10,1,fmt)
    call process0(10,1234,fmt)
    call process0(16,254,fmt)
    call process0(16,3854,fmt)
  end subroutine confused

  subroutine process0(b,n,fmt)
    integer, intent(in) :: b, n
    character(len=*), intent(in) :: fmt
    print fmt,n,b,sum(antibase(b, n))
  end subroutine process0
end program digit_sum
