program BoundedTest
  use Bounded
  implicit none

  type(BoundedInteger)     ::  a, b, c

  call set_bound(a, 1, 10)
  ! if we want to stop the program if a is out of bounds...
  ! call set_bound(a, 1, 10, critical=.true.)
  call set_bound(b, 1, 10)
  call set_bound(c, 1, 10)
  ! if we want to init c to a specific value...:
  ! call set_bound(c, 1, 10, value=6)

  a = 1         ! ok
  a = 4         ! ok
  a = -1        ! warning (a=1)
  a = 11        ! warning (a=10)
  a = 3         ! ok
  b = a         ! ok
  c = a + b     ! ok (3+3)
  c = c + a     ! ok (6+3=9)
  c = c + b     ! warning (c=10)

end program BoundedTest
