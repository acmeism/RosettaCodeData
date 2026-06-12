! Minimal Enclosing Circle (Welzl's algorithm) in Fortran

module geometry
  implicit none

  type :: Point
    real(8) :: x
    real(8) :: y
  end type Point

  type :: Circle
    type(Point) :: center
    real(8) :: radius
  end type Circle

contains

  function distance(a, b) result(d)
    type(Point), intent(in) :: a, b
    real(8) :: d
    d = sqrt((a%x - b%x)**2 + (a%y - b%y)**2)
  end function distance

  function inCircle(p, c) result(isInside)
    type(Point), intent(in) :: p
    type(Circle), intent(in) :: c
    logical :: isInside
    isInside = distance(p, c%center) <= c%radius
  end function inCircle

  function circleOf2(a, b) result(res)
    type(Point), intent(in) :: a, b
    type(Circle) :: res
    res%center%x = (a%x + b%x) / 2.0d0
    res%center%y = (a%y + b%y) / 2.0d0
    res%radius = distance(a, b) / 2.0d0
  end function circleOf2

  function circleOf3(a, b, c) result(res)
    type(Point), intent(in) :: a, b, c
    type(Circle) :: res
    type(Point) :: bma, cma
    real(8) :: BB, CC, DD

    bma%x = b%x - a%x
    bma%y = b%y - a%y
    cma%x = c%x - a%x
    cma%y = c%y - a%y

    BB = bma%x**2 + bma%y**2
    CC = cma%x**2 + cma%y**2
    DD = 2.0d0 * (bma%x * cma%y - bma%y * cma%x)

    res%center%x = (cma%y * BB - bma%y * CC) / DD + a%x
    res%center%y = (bma%x * CC - cma%x * BB) / DD + a%y
    res%radius = distance(res%center, a)
  end function circleOf3

  function trivial(r, n) result(res)
    type(Point), intent(in) :: r(:)
    integer, intent(in) :: n
    type(Circle) :: res

    select case (n)
    case (0)
      res%center%x = 0.0d0
      res%center%y = 0.0d0
      res%radius = 0.0d0
    case (1)
      res%center = r(1)
      res%radius = 0.0d0
    case (2)
      res = circleOf2(r(1), r(2))
    case (3)
      res = circleOf3(r(1), r(2), r(3))
    case default
      print *, "There shouldn't be more than 3 points."
    end select
  end function trivial

  recursive function welzlR(p, np, r, nr) result(res)
    type(Point), intent(in) :: p(:)
    integer, intent(in) :: np
    type(Point), intent(in) :: r(:)
    integer, intent(in) :: nr
    type(Circle) :: res
    type(Point), allocatable :: new_p(:), new_r(:)
    type(Circle) :: d
    integer :: i

    if (np == 0 .or. nr == 3) then
      res = trivial(r, nr)
      return
    end if

    allocate(new_p(np-1))
    new_p = p(2:np)
    d = welzlR(new_p, np-1, r, nr)
    if (inCircle(p(1), d)) then
      res = d
      deallocate(new_p)
      return
    end if

    allocate(new_r(nr+1))
    if (nr > 0) new_r(1:nr) = r(1:nr)
    new_r(nr+1) = p(1)
    res = welzlR(new_p, np-1, new_r, nr+1)
    deallocate(new_p)
    deallocate(new_r)
  end function welzlR

  subroutine welzl(points, n)
    type(Point), intent(in) :: points(:)
    integer, intent(in) :: n
    type(Point), allocatable :: r(:)
    type(Circle) :: c
    integer :: i

    allocate(r(0))
    c = welzlR(points, n, r, 0)
    deallocate(r)

    write(*, '(A)', advance="no") 'Points: ('
    do i = 1, n
      if (i > 1) write(*, '(A)', advance="no") ', '
      write(*, '("(", G0.4, ",", G0.4, ")")', advance="no") points(i)%x, points(i)%y
    end do
    write(*, '(A)', advance="no") ')'
    write(*, '(A, F0.4, A, F0.4, A, F0.15)') ' ==> Centre: (', c%center%x, ', ', c%center%y, ') Radius: ', c%radius
  end subroutine welzl

end module geometry

program test_welzl
  use geometry
  implicit none

  type(Point), allocatable :: tests1(:), tests2(:)

  ! Test case 1: 3 points
  allocate(tests1(3))
  tests1(1)%x = 0.0d0; tests1(1)%y = 0.0d0
  tests1(2)%x = 0.0d0; tests1(2)%y = 1.0d0
  tests1(3)%x = 1.0d0; tests1(3)%y = 0.0d0

  ! Test case 2: 5 points
  allocate(tests2(5))
  tests2(1)%x = 5.0d0; tests2(1)%y = -2.0d0
  tests2(2)%x = -3.0d0; tests2(2)%y = -2.0d0
  tests2(3)%x = -2.0d0; tests2(3)%y = 5.0d0
  tests2(4)%x = 1.0d0; tests2(4)%y = 6.0d0
  tests2(5)%x = 0.0d0; tests2(5)%y = 2.0d0

  call welzl(tests1, 3)
  call welzl(tests2, 5)

  print *, "Press Enter to exit."
  read(*,*)
end program test_welzl
