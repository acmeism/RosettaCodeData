program Map
  implicit none

  real :: t
  integer :: i

  do i = 0, 10
    t = Maprange((/0.0, 10.0/), (/-1.0, 0.0/), real(i))
    write(*,*) i, " maps to ", t
  end do

contains

function Maprange(a, b, s)
  real :: Maprange
  real, intent(in) :: a(2), b(2), s

  Maprange = (s-a(1)) * (b(2)-b(1)) / (a(2)-a(1)) + b(1)

end function Maprange
end program Map
