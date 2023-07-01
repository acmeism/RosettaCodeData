module functions_module
   implicit none
   private ! all by default
   public :: f,g

contains

   pure function  f(x)
      implicit none
      real, intent(in) :: x
      real :: f
      f = sin(x)
   end function f

   pure function  g(x)
      implicit none
      real, intent(in) :: x
      real :: g
      g = cos(x)
   end function g

end module functions_module

module compose_module
   implicit none
   private ! all by default
   public :: compose

   interface
      pure function  f(x)
         implicit none
         real, intent(in) :: x
         real :: f
      end function f

      pure function  g(x)
         implicit none
         real, intent(in) :: x
         real :: g
      end function g
   end interface

contains

   impure function  compose(x, fi, gi)
      implicit none
      real, intent(in) :: x
      procedure(f), optional :: fi
      procedure(g), optional :: gi
      real :: compose

      procedure (f), pointer, save :: fpi => null()
      procedure (g), pointer, save :: gpi => null()

      if(present(fi) .and. present(gi))then
         fpi => fi
         gpi => gi
         compose = 0
         return
      endif

      if(.not. associated(fpi)) error stop "fpi"
      if(.not. associated(gpi)) error stop "gpi"

      compose = fpi(gpi(x))

   contains

   end function compose

end module compose_module

program test_compose
   use functions_module
   use compose_module
   implicit none
   write(*,*) "prepare compose:", compose(0.0, f,g)
   write(*,*) "run compose:", compose(0.5)
end program test_compose
