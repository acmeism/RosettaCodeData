subroutine fibber(a,b,c,d)
  ! compute most significant digits, Fibonacci like.
  implicit none
  integer (kind=8), intent(in) :: a,b
  integer (kind=8), intent(out) :: c,d
  d = a + b
  if (15 .lt. log10(float(d))) then
    c = b/10
    d = d/10
  else
    c = b
  endif
end subroutine fibber

integer function leadingDigit(a)
  implicit none
  integer (kind=8), intent(in) :: a
  integer (kind=8) :: b
  b = a
  do while (9 .lt. b)
    b = b/10
  end do
  leadingDigit = transfer(b,leadingDigit)
end function leadingDigit

real function benfordsLaw(a)
  implicit none
  integer, intent(in) :: a
  benfordsLaw = log10(1.0 + 1.0 / a)
end function benfordsLaw

program benford

  implicit none

  interface

    subroutine fibber(a,b,c,d)
      implicit none
      integer (kind=8), intent(in) :: a,b
      integer (kind=8), intent(out) :: c,d
    end subroutine fibber

    integer function leadingDigit(a)
      implicit none
      integer (kind=8), intent(in) :: a
    end function leadingDigit

    real function benfordsLaw(a)
      implicit none
      integer, intent(in) :: a
    end function benfordsLaw

  end interface

  integer (kind=8) :: a, b, c, d
  integer :: i, count(10)
  data count/10*0/
  a = 1
  b = 1
  do i = 1, 1001
    count(leadingDigit(a)) = count(leadingDigit(a)) + 1
    call fibber(a,b,c,d)
    a = c
    b = d
  end do
  write(6,*) (benfordsLaw(i),i=1,9),'THE LAW'
  write(6,*) (count(i)/1000.0 ,i=1,9),'LEADING FIBONACCI DIGIT'
end program benford
