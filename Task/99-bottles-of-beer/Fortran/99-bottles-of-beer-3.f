module song_typedefs
   implicit none

   private ! all
   public :: TBottles

   type, abstract :: TContainer
      integer :: quantity
   contains
      ! deferred method i.e. abstract method =  must be overridden in extended type
      procedure(take_one), deferred, pass :: take_one
      procedure(show_quantity), deferred, pass :: show_quantity
   end type TContainer


   abstract interface
      subroutine  take_one(this)
         import TContainer
         implicit none
         class(TContainer) :: this
      end subroutine take_one
      subroutine  show_quantity(this)
         import TContainer
         implicit none
         class(TContainer) :: this
      end subroutine show_quantity
   end interface

   ! extended derived type
   type, extends(TContainer) :: TBottles
   contains
      procedure, pass :: take_one => take_one_bottle
      procedure, pass :: show_quantity => show_bottles
      final :: finalize_bottles
   end type TBottles

 contains

   subroutine  show_bottles(this)
      implicit none
      class(TBottles) :: this
      ! integer :: show_bottles
      character(len=*), parameter :: bw0 = "No more bottles of beer on the wall,"
      character(len=*), parameter :: bwx = "bottles of beer on the wall,"
      character(len=*), parameter :: bw1 = "bottle of beer on the wall,"
      character(len=*), parameter :: bb0 = "no more bottles of beer."
      character(len=*), parameter :: bbx = "bottles of beer."
      character(len=*), parameter :: bb1 = "bottle of beer."
      character(len=*), parameter :: fmtxdd = "(I2,1X,A28,1X,I2,1X,A16)"
      character(len=*), parameter :: fmtxd = "(I1,1X,A28,1X,I1,1X,A16)"
      character(len=*), parameter :: fmt1 = "(I1,1X,A27,1X,I1,1X,A15)"
      character(len=*), parameter :: fmt0 = "(A36,1X,A24)"

      select case (this % quantity)
       case (10:)
         write(*,fmtxdd) this % quantity, bwx, this % quantity, bbx
       case (2:9)
         write(*,fmtxd) this % quantity, bwx, this % quantity, bbx
       case (1)
         write(*,fmt1) this % quantity, bw1, this % quantity, bb1
       case (0)
         write(*,*)
         write(*,fmt0) bw0, bb0
       case default
         write(*,*)"Warning!  Number of bottles exception, error 42. STOP"
         stop
      end select
      !    show_bottles = this % quantity
   end subroutine show_bottles

   subroutine  take_one_bottle(this) ! bind(c, name='take_one_bottle')
      implicit none
      class(TBottles) :: this
      ! integer :: take_one_bottle
      character(len=*), parameter :: t1 = "Take one down and pass it around,"
      character(len=*), parameter :: remx = "bottles of beer on the wall."
      character(len=*), parameter :: rem1 = "bottle of beer on the wall."
      character(len=*), parameter :: rem0 = "no more bottles of beer on the wall."
      character(len=*), parameter :: fmtx = "(A33,1X,I2,1X,A28)"
      character(len=*), parameter :: fmt1 = "(A33,1X,I2,1X,A27)"
      character(len=*), parameter :: fmt0 = "(A33,1X,A36)"

      this % quantity = this % quantity -1

      select case (this%quantity)
       case (2:)
         write(*,fmtx) t1, this%quantity, remx
       case (1)
         write(*,fmt1) t1, this%quantity, rem1
       case (0)
         write(*,fmt0) t1, rem0
       case (-1)
         write(*,'(A66)') "Go to the store and buy some more, 99 bottles of beer on the wall."
       case default
         write(*,*)"Warning!  Number of bottles exception, error 42. STOP"
         stop
      end select

   end subroutine take_one_bottle

   subroutine  finalize_bottles(bottles)
      implicit none
      type(TBottles) :: bottles
   ! here can be more code
   end subroutine finalize_bottles

end module song_typedefs

!-----------------------------------------------------------------------
!Main program
!-----------------------------------------------------------------------
program    bottles_song
   use song_typedefs
   implicit none
   integer, parameter :: MAGIC_NUMBER = 99
   type(TBottles), target :: BTLS

   BTLS = TBottles(MAGIC_NUMBER)

   call make_song(BTLS)

 contains

   subroutine make_song(bottles)
      type(TBottles) :: bottles
      do while(bottles%quantity >= 0)
         call bottles%show_quantity()
         call bottles%take_one()
      enddo
   end subroutine make_song

end program bottles_song
