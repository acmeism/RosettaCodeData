module FuncContainer
  implicit none
contains

  function func1(x)
    real :: func1
    real, intent(in) :: x

    func1 = x**2.0
  end function func1

  function func2(x)
    real :: func2
    real, intent(in) :: x

    func2 = x**2.05
  end function func2

end module FuncContainer

program FuncArg
  use FuncContainer
  implicit none

  print *, "Func1"
  call asubroutine(func1)

  print *, "Func2"
  call asubroutine(func2)

contains

  subroutine asubroutine(f)
    ! the following interface is redundant: can be omitted
    interface
       function f(x)
         real, intent(in) :: x
         real :: f
       end function f
    end interface
    real :: px

    px = 0.0
    do while( px < 10.0 )
       print *, px, f(px)
       px = px + 1.0
    end do
  end subroutine asubroutine

end program FuncArg
