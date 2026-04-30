! Yellowstone Sequence - Code Golf Version
! Demonstrates concise Fortran (but keep it readable!)
program yellowstone_golf
   implicit none
   integer :: y(100), i, c
   logical :: u(1000) = .false.

   ! First 3 terms
   y(1:3) = [(i, i=1,3)]
   u(1:3) = .true.

   ! Generate rest
   do i = 4, 100
      c = 1
      do while (u(c) .or. gcd(c,y(i-1))/=1 .or. gcd(c,y(i-2))==1)
         c = c + 1
      end do
      y(i) = c
      u(c) = .true.
   end do

   ! Output
   print '(A)', "First 30 Yellowstone numbers:"
   print '(10I5)', y(1:30)

contains
!   pure integer function gcd(a,b) !Euclid's method
!      integer, intent(in) :: a, b
!      integer :: x, y, t
!      x = a; y = b
!      do while (y /= 0)
!         t = y; y = mod(x,y); x = t
!      end do
!      gcd = x
!   end function
pure integer function gcd(a, b) !Stein's method
    ! Added and used Steins method of finding the GCD
    ! simply because everyone else was using Euclid's method
   integer, intent(in) :: a, b
   integer :: x, y, shift

   x = abs(a)
   y = abs(b)
   ! Handle trivial cases
   if (a == 0) then
      gcd = y
      return
   else if (b == 0) then
      gcd = x
      return
   end if

   ! Count common factors of 2
   shift = 0
   do while ((iand(x,1) == 0) .and. (iand(y,1) == 0))
      x = ishft(x,-1)
      y = ishft(y,-1)
      shift = shift + 1
   end do

   ! Divide x by 2 until odd
   do while (iand(x,1) == 0)
      x = ishft(x,-1)
   end do

   do ! Divide y by 2 until odd
      do while (iand(y,1) == 0)
         y = ishft(y,-1)
      end do

      ! Ensure x <= y
      if (x > y) then
         ! swap
         x = x + y
         y = x - y
         x = x - y
      end if
      y = y - x
      if (y == 0) exit
   end do

   gcd = ishft(x, shift)
end function gcd

end program yellowstone_golf
