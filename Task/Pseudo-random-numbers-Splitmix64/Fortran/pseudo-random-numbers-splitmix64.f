module splitmix64
  use, intrinsic :: iso_fortran_env, only : uint64, real64 ! unsigned integer to get the same output
  implicit none

  type, public :: splitmix64_t
      unsigned(uint64), private :: state = 123456u_8
  contains
      procedure, public :: init
      procedure, public :: next_int
      procedure, public :: next_float
  end type splitmix64_t

  unsigned(uint64), parameter :: c1 = 11400714819323198485u_8
  unsigned(uint64), parameter :: c2 = 13787848793156543929u_8
  unsigned(uint64), parameter :: c3 = 10723151780598845931u_8

contains
  subroutine init(self, seed)
      !! Initialize state
      class(splitmix64_t), intent(inout) :: self
      unsigned(uint64), intent(in)       :: seed

      self%state = seed
  end subroutine init

  unsigned(uint64) function next_int(self) result(res)
      !! Return 8-byte integer
      class(splitmix64_t), intent(inout) :: self

      self%state = self%state + c1
      res = self%state
      res = ieor(res, shiftr(res, 30)) * c2
      res = ieor(res, shiftr(res, 27)) * c3
      res = ieor(res, shiftr(res, 31))
  end function next_int

  real(real64) function next_float(self) result(res)
      !! return 8-byte floating point number
      class(splitmix64_t), intent(inout) :: self
      unsigned(uint64)                   :: rand_int

      rand_int = self%next_int()
      rand_int  = ior(shiftl(1023u_8, 52), shiftr(rand_int, 12))
      res = transfer(rand_int, res) - 1.0_real64
  end function next_float
end module splitmix64


program main
    use iso_fortran_env, only : uint64, real64
    use splitmix64
    implicit none

    integer :: i, j
    integer, dimension(0:4) :: v = [0,0,0,0,0]
    type(splitmix64_t) :: rng

    call rng % init(1234567u_8)
    do i = 1,5
        print "(i0)", rng % next_int()
    end do

    call rng%init(987654321u_8)

    do i = 1,100000
        j = int(rng%next_float()*5.0_real64)
        v(j) = v(j) + 1
    end do

    do i = 0, 4
        write(*, fmt="(i0, a, i0, 2x)", advance="no") i, ": ", v(i)
    end do
    write(*,*)
end program main
