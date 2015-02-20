Program Hickerson
! 3 February 2014
! not all Fortran compilers provide REAL*16 and INTEGER*8
implicit none
real(kind=kind(1q0)) :: s
integer(kind=kind(1_8)) :: i,n,f,is

do n = 1, 17
      s = 0.5q0 / log(2q0)
      do i = 1,n
         s = (s * i) / log(2q0)
      end do

      is = s
      f = (s-is)*10                 !first digit after decimal point
      if (f == 0 .or. f == 9) then
         write(*,10)n,s,''
      else
         write(*,10)n,s,' NOT'
      endif
end do
10 format('h(',i2,') = ',F23.3,' is',A,' an almost-integer')
end program Hickerson
