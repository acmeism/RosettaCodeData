!-----------------------------------------------------------------------
!Module accuracy defines precision and some constants
!-----------------------------------------------------------------------
module accuracy_module
   implicit none
   integer, parameter, public :: rdp = kind(1.d0)
   ! constants
   real(rdp), parameter :: pi=3.141592653589793238462643383279502884197_rdp
end module accuracy_module

!-----------------------------------------------------------------------
!Module typedefs_module contains abstract derived type and extended type definitions.
! Note that a reserved word "class" in Fortran is used to describe
! some polymorphic variable  whose data type may vary at run time.
!-----------------------------------------------------------------------
module typedefs_module
   use accuracy_module
   implicit none

   private ! all
   public :: TPoint, TShape, TCircle, TRectangle, TSquare ! public only these defined derived types

   ! abstract derived type
   type, abstract :: TShape
      real(rdp) :: area
      character(len=:),allocatable :: name
   contains
      ! deferred method i.e. abstract method =  must be overridden in extended type
      procedure(calculate_area), deferred,pass :: calculate_area
   end type TShape
   ! just declaration of the abstract method/procedure for TShape type
   abstract interface
      function  calculate_area(this)
         use accuracy_module
         import TShape !imports TShape type from host scoping unit and makes it accessible here
         implicit none
         class(TShape) :: this
         real(rdp) :: calculate_area

      end function calculate_area
   end interface

   ! auxiliary derived type
   type TPoint
      real(rdp) :: x,y
   end type TPoint

   ! extended derived type
   type, extends(TShape) :: TCircle
      real(rdp) :: radius
      real(rdp), private :: diameter
      type(TPoint) :: centre
   contains
      procedure, pass :: calculate_area => calculate_circle_area
      procedure, pass :: get_circle_diameter
      final :: finalize_circle
   end type TCircle

   ! extended derived type
   type, extends(TShape) :: TRectangle
      type(TPoint) :: A,B,C,D
   contains
      procedure, pass :: calculate_area => calculate_rectangle_area
      final :: finalize_rectangle
   end type TRectangle

   ! extended derived type
   type, extends(TRectangle) :: TSquare
   contains
      procedure, pass :: calculate_area => calculate_square_area
      final :: finalize_square
   end type TSquare

 contains

   ! finalization subroutines for each type
   ! They called recursively, i.e. finalize_rectangle
   ! will be called after finalize_square subroutine
   subroutine finalize_circle(x)
      type(TCircle), intent(inout) :: x
      write(*,*) "Deleting TCircle object"
   end subroutine finalize_circle

   subroutine finalize_rectangle(x)
      type(TRectangle), intent(inout) :: x
      write(*,*) "Deleting also TRectangle object"
   end subroutine finalize_rectangle

   subroutine finalize_square(x)
      type(TSquare), intent(inout) :: x
      write(*,*) "Deleting TSquare object"
   end subroutine finalize_square

   function calculate_circle_area(this)
      implicit none
      class(TCircle) :: this
      real(rdp) :: calculate_circle_area
      this%area = pi * this%radius**2
      calculate_circle_area = this%area
   end function calculate_circle_area

   function calculate_rectangle_area(this)
      implicit none
      class(TRectangle) :: this
      real(rdp) :: calculate_rectangle_area
      ! here could be more code
      this%area = 1
      calculate_rectangle_area = this%area
   end function calculate_rectangle_area

   function calculate_square_area(this)
      implicit none
      class(TSquare) :: this
      real(rdp) :: calculate_square_area
      ! here could be more code
      this%area = 1
      calculate_square_area = this%area
   end function calculate_square_area

   function  get_circle_diameter(this)
      implicit none
      class(TCircle) :: this
      real(rdp) :: get_circle_diameter
      this % diameter = 2.0_rdp * this % radius
      get_circle_diameter = this % diameter
   end function get_circle_diameter

end module typedefs_module

!-----------------------------------------------------------------------
!Main program
!-----------------------------------------------------------------------
program    rosetta_class
   use accuracy_module
   use typedefs_module
   implicit none

   ! we need this subroutine in order to show the finalization
   call test_types()

 contains

   subroutine test_types()
      implicit none
      ! declare object of type TPoint
      type(TPoint), target :: point
      ! declare object of type TCircle
      type(TCircle),target :: circle
      ! declare object of type TSquare
      type(TSquare),target :: square

      ! declare pointers
      class(TPoint), pointer :: ppo
      class(TCircle), pointer :: pci
      class(TSquare), pointer :: psq

      !constructor
      point = TPoint(5.d0,5.d0)
      ppo => point
      write(*,*) "x=",point%x,"y=",point%y

      pci => circle

      pci % radius = 1
      write(*,*) pci % radius
      ! write(*,*) pci % diameter !No,it is a PRIVATE component
      write(*,*) pci % get_circle_diameter()
      write(*,*) pci % calculate_area()
      write(*,*) pci % area

      psq => square

      write(*,*) psq % area
      write(*,*) psq % calculate_area()
      write(*,*) psq % area
   end subroutine test_types

end program rosetta_class
