!-----------------------------------------------------------------------
!Module polymorphic_copy_example_module
!-----------------------------------------------------------------------
module polymorphic_copy_example_module
   implicit none
   private ! all by default
   public :: T,S

   type, abstract :: T
   contains
      procedure (T_procedure1), deferred, pass :: identify
      procedure (T_procedure2), deferred, pass :: duplicate
   end type T


   abstract interface
      subroutine T_procedure1(this)
         import  :: T
         class(T), intent(inout) :: this
      end subroutine T_procedure1
      function T_procedure2(this) result(Tobj)
         import  :: T
         class(T), intent(inout) :: this
         class(T), allocatable :: Tobj
      end function T_procedure2
   end interface

   type, extends(T) :: S
   contains
      procedure, pass :: identify
      procedure, pass :: duplicate
   end type S

 contains

   subroutine  identify(this)
      implicit none
      class(S), intent(inout) :: this
      write(*,*) "S"
   end subroutine identify

   function duplicate(this) result(obj)
      class(S), intent(inout) :: this
      class(T), allocatable :: obj
      allocate(obj, source = S())
   end function duplicate

end module polymorphic_copy_example_module

!-----------------------------------------------------------------------
!Main program test
!-----------------------------------------------------------------------
program    test
   use polymorphic_copy_example_module
   implicit none

   class(T), allocatable :: Sobj
   class(T), allocatable :: Sclone

   allocate(Sobj, source = S())
   allocate(Sclone, source = Sobj % duplicate())

   call Sobj % identify()
   call Sclone % identify()

end program test
