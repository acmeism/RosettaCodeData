module modular_arithmetic
  implicit none

  type :: modular
     integer :: val
     integer :: modulus
  end type modular

  interface operator(+)
     module procedure modular_modular_add
     module procedure modular_integer_add
  end interface operator(+)

  interface operator(**)
     module procedure modular_integer_pow
  end interface operator(**)

contains

  function modular_modular_add (a, b) result (c)
    type(modular), intent(in) :: a
    type(modular), intent(in) :: b
    type(modular) :: c

    if (a%modulus /= b%modulus) error stop
    c%val = modulo (a%val + b%val, a%modulus)
    c%modulus = a%modulus
  end function modular_modular_add

  function modular_integer_add (a, i) result (c)
    type(modular), intent(in) :: a
    integer, intent(in) :: i
    type(modular) :: c

    c%val = modulo (a%val + i, a%modulus)
    c%modulus = a%modulus
  end function modular_integer_add

  function modular_integer_pow (a, i) result (c)
    type(modular), intent(in) :: a
    integer, intent(in) :: i
    type(modular) :: c

    ! One cannot simply use the integer ** operator and then compute
    ! the least residue, because the integers will overflow. Let us
    ! instead use the right-to-left binary method:
    ! https://en.wikipedia.org/w/index.php?title=Modular_exponentiation&oldid=1136216610#Right-to-left_binary_method

    integer :: modulus
    integer :: base
    integer :: exponent

    modulus = a%modulus
    exponent = i

    if (modulus < 1) error stop
    if (exponent < 0) error stop

    c%modulus = modulus
    if (modulus == 1) then
       c%val = 0
    else
       c%val = 1
       base = modulo (a%val, modulus)
       do while (exponent > 0)
          if (modulo (exponent, 2) /= 0) then
             c%val = modulo (c%val * base, modulus)
          end if
          exponent = exponent / 2
          base = modulo (base * base, modulus)
       end do
    end if
  end function modular_integer_pow

end module modular_arithmetic

! If one uses the extension .F90 instead of .f90, then gfortran will
! pass the program through the C preprocessor. Thus one can write f(x)
! without considering the type of the argument
#define f(x) ((x)**100 + (x) + 1)

program modular_arithmetic_task
  use, intrinsic :: iso_fortran_env
  use, non_intrinsic :: modular_arithmetic
  implicit none

  type(modular) :: x, y

  x = modular(10, 13)
  y = f(x)

  write (*, '("    modulus 13:  ", I0)') y%val
  write (*, '("floating point:  ", E55.50)') f(10.0_real64)

end program modular_arithmetic_task
