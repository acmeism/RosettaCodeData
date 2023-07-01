module logic
  implicit none

contains

function xor(a, b)
  logical :: xor
  logical, intent(in) :: a, b

  xor = (a .and. .not. b) .or. (b .and. .not. a)
end function xor

function halfadder(a, b, c)
  logical :: halfadder
  logical, intent(in)  :: a, b
  logical, intent(out) :: c

  halfadder = xor(a, b)
  c = a .and. b
end function halfadder

function fulladder(a, b, c0, c1)
  logical :: fulladder
  logical, intent(in)  :: a, b, c0
  logical, intent(out) :: c1
  logical :: c2, c3

  fulladder = halfadder(halfadder(c0, a, c2), b, c3)
  c1 = c2 .or. c3
end function fulladder

subroutine fourbitadder(a, b, s)
  logical, intent(in)  :: a(0:3), b(0:3)
  logical, intent(out) :: s(0:4)
  logical :: c0, c1, c2

  s(0) = fulladder(a(0), b(0), .false., c0)
  s(1) = fulladder(a(1), b(1), c0, c1)
  s(2) = fulladder(a(2), b(2), c1, c2)
  s(3) = fulladder(a(3), b(3), c2, s(4))
end subroutine fourbitadder
end module

program Four_bit_adder
  use logic
  implicit none

  logical, dimension(0:3) :: a, b
  logical, dimension(0:4) :: s
  integer, dimension(0:3) :: ai, bi
  integer, dimension(0:4) :: si
  integer :: i, j

  do i = 0, 15
    a(0) = btest(i, 0); a(1) = btest(i, 1); a(2) = btest(i, 2); a(3) = btest(i, 3)
    where(a)
      ai = 1
    else where
      ai = 0
    end where
    do j = 0, 15
      b(0) = btest(j, 0); b(1) = btest(j, 1); b(2) = btest(j, 2); b(3) = btest(j, 3)
      where(b)
        bi = 1
      else where
        bi = 0
      end where
      call fourbitadder(a, b, s)
      where (s)
        si = 1
      elsewhere
        si = 0
      end where
      write(*, "(4i1,a,4i1,a,5i1)") ai(3:0:-1), " + ", bi(3:0:-1), " = ", si(4:0:-1)
    end do
  end do
end program
