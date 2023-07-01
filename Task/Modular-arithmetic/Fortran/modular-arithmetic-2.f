module modular_arithmetic
  implicit none

  type :: modular_integer
     integer :: val
     integer :: modulus
  end type modular_integer

  interface operator(+)
     module procedure add
  end interface operator(+)

  interface operator(*)
     module procedure mul
  end interface operator(*)

  interface operator(**)
     module procedure npow
  end interface operator(**)

contains

  function modular (val, modulus) result (modint)
    integer, intent(in) :: val, modulus
    type(modular_integer) :: modint

    modint%val = modulo (val, modulus)
    modint%modulus = modulus
  end function modular

  subroutine write_number (x)
    class(*), intent(in) :: x

    select type (x)
    class is (modular_integer)
       write (*, '(I0)', advance = 'no') x%val
    type is (integer)
       write (*, '(I0)', advance = 'no') x
    class default
       error stop
    end select
  end subroutine write_number

  function add (a, b) result (c)
    class(*), intent(in) :: a, b
    class(*), allocatable :: c

    select type (a)
    class is (modular_integer)
       select type (b)
       class is (modular_integer)
          if (a%modulus /= b%modulus) error stop
          allocate (c, source = modular (a%val + b%val, a%modulus))
       type is (integer)
          allocate (c, source = modular (a%val + b, a%modulus))
       class default
          error stop
       end select
    type is (integer)
       select type (b)
       class is (modular_integer)
          allocate (c, source = modular (a + b%val, b%modulus))
       type is (integer)
          allocate (c, source = a + b)
       class default
          error stop
       end select
    class default
       error stop
    end select
  end function add

  function mul (a, b) result (c)
    class(*), intent(in) :: a, b
    class(*), allocatable :: c

    select type (a)
    class is (modular_integer)
       select type (b)
       class is (modular_integer)
          if (a%modulus /= b%modulus) error stop
          allocate (c, source = modular (a%val * b%val, a%modulus))
       type is (integer)
          allocate (c, source = modular (a%val * b, a%modulus))
       class default
          error stop
       end select
    type is (integer)
       select type (b)
       class is (modular_integer)
          allocate (c, source = modular (a * b%val, b%modulus))
       type is (integer)
          allocate (c, source = a * b)
       class default
          error stop
       end select
    class default
       error stop
    end select
  end function mul

  function npow (a, i) result (c)
    class(*), intent(in) :: a
    integer, intent(in) :: i
    class(*), allocatable :: c

    class(*), allocatable :: base
    integer :: exponent, exponent_halved

    if (i < 0) error stop

    select type (a)
    class is (modular_integer)
       allocate (c, source = modular (1, a%modulus))
    class default
       c = 1
    end select

    allocate (base, source = a)

    exponent = i
    do while (exponent /= 0)
       exponent_halved = exponent / 2
       if (2 * exponent_halved /= exponent) c = base * c
       base = base * base
       exponent = exponent_halved
    end do
  end function npow

end module modular_arithmetic

program modular_arithmetic_task
  use, non_intrinsic :: modular_arithmetic
  implicit none

  write (*, '("f(10) ≅ ")', advance = 'no')
  call write_number (f (modular (10, 13)))
  write (*, '("   (mod 13)")')

  write (*, '()')
  write (*, '("f applied to a regular integer would overflow, so, in what")')
  write (*, '("follows, instead we use g(x) = x**2 + x + 1")')
  write (*, '()')

  write (*, '("g(10) = ")', advance = 'no')
  call write_number (g (10))
  write (*, '()')
  write (*, '("g(10) ≅ ")', advance = 'no')
  call write_number (g (modular (10, 13)))
  write (*, '("   (mod 13)")')
contains

  function f(x) result (y)
    class(*), intent(in) :: x
    class(*), allocatable :: y

    y = x**100 + x + 1
  end function f

  function g(x) result (y)
    class(*), intent(in) :: x
    class(*), allocatable :: y

    y = x**2 + x + 1
  end function g

end program modular_arithmetic_task
