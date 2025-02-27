!	This is a nice alternative to the usual recursive Hanoi solutions. It runs about 10x
!       faster than a well crafted recursive solution for 30 disks.
      SUBROUTINE olives(Numdisk)
!>  This is an implementation of "Olive's Algorithm"
!!  The “simpler” algorithm where the smallest disk moves circularly every second
!!  move is attributed to Raoul Olive, the nephew of Edouard Lucas, the inventor of the
!!  Towers of Hanoi puzzle. We alternately move disk one in it's established direction
!!  Then we move the one of the 'non-one' disks, depending on the legality of the move.
!!  In this implementation, I use a small array of the stack entities. This allows us
!!  to easily find the stack where the disk to be moved resides.
      USE data_defs
      IMPLICIT NONE
!
! PARAMETER definitions
!
      INTEGER(int32) , PARAMETER  ::  bigm = maxpos*3
!
! Dummy arguments
!
      INTEGER(int32)  ::  Numdisk
      INTENT (IN) Numdisk
!
! Local variables
!
      TYPE(stack) , POINTER  ::  a , b , c , on_now   !< on_now is where disk 1 is
      TYPE(stack) , TARGET , DIMENSION(3) ::  abc !< The three stack are put in an array for identification i.e. abc(1)%stack_id = 1
      INTEGER  ::  direction !< Direction of disk1, negative is counter clockwise, positive = clockwise
      INTEGER(int32)  ::  i , j

      DATA(abc(i)%height , i = 1 , 3)/3*0/
      DATA(abc(i)%stack_id , i = 1 , 3)/1 , 2 , 3/
      DATA((abc(i)%disks(j),i = 1,3) , j = 1 , maxpos)/bigm*0/
! Code starts here
!
! Move numdisks from A to C using B as intermediate
!
      a => abc(1)
      b => abc(2)
      c => abc(3)
      on_now => a   !< Point to the starting pole
      a%height = Numdisk    !< A = the starting pole
!
      last_move = -1
!
      a%disks = [(Numdisk + 1 - j, j = 1, Numdisk)]

      IF( btest(Numdisk,0) )THEN        !< First move rule always involves disk 1, test odd/even for first move
         CALL move(a , c)
         direction = -1         ! Counter clockwise
         on_now => c
      ELSE
         CALL move(a , b)
         direction = 1          ! Clockwise
         on_now => b
      END IF
!
      DO WHILE ( c%height/=Numdisk )
!
         SELECT CASE(on_now%stack_id)   !< Depending where disk one is, make a legal move
         CASE(1)    !< One is on stack 1 i.e. a so we can only make a legal move in between b and c
            IF( legal(b,c) )THEN
               CALL move(b , c)
            ELSE
               CALL move(c , b)
            END IF
         CASE(2)                        ! Disk one on stack 2 i.e. "b"
            IF( legal(a,c) )THEN
               CALL move(a , c)
            ELSE
               CALL move(c , a)
            END IF
         CASE(3)                        ! Disk one on stack 3 i.e. "c"
            IF( legal(a,b) )THEN
               CALL move(a , b)
            ELSE
               CALL move(b , a)
            END IF
         END SELECT

!< Now move disk 1 in the direction it was heading
         i = on_now%stack_id + direction       !< Increment the stack a->b->c->a or vice versa Decrement the stack c->b->a->c
!< Note that here we use the stack_id to figure out which disk destination to use. As we increment or decrement the stack counter
!! we reset it to the correct disk when it is outside the 1..3 range. It is set so as to maintain the correct disk direction.
         SELECT CASE(i)
         CASE(0)
            i = 3
         CASE(1:3)
         CASE(4)
            i = 1
         END SELECT

         CALL move(on_now , abc(i))
         on_now => abc(i)
      END DO
      PRINT '(*(i0,2x))' , (c%disks(i) , i = 1 , Numdisk) ! Print final disk configuration
      on_now => null()
!
      RETURN
      END SUBROUTINE olives
      SUBROUTINE Move(Donor , Receiver)
      USE Data_defs
      IMPLICIT NONE

! Dummy arguments
!
      TYPE(stack)  ::  Donor , Receiver
      INTENT (INOUT) Donor , Receiver
! Code starts here
!$GCC$ attributes INLINE :: MOVE
!
! Code starts here
      last_move = Receiver%Stack_id
      Receiver%Height = Receiver%Height + 1           ! make slot in receiver
      Receiver%Disks(Receiver%Height) = Donor%Disks(Donor%Height)     !Move the disk
      Donor%Disks(Donor%Height) = 0                   ! Black it out
      Donor%Height = Donor%Height - 1                 ! Decrement the donor height
      RETURN
      END SUBROUTINE Move
    Module data_defs
      IMPLICIT NONE
!
! PARAMETER definitions
!
      INTEGER , PARAMETER  ::  int32 = selected_int_kind(8) , &
                             & int64 = selected_int_kind(16)

      INTEGER(int32) , PARAMETER  ::  maxpos = 40        ! Maximum possible disks without a huge blowout
!
! Derived Type definitions
!
      TYPE :: stack
         INTEGER(int32)  ::  stack_id
         INTEGER(int32)  ::  height
         INTEGER(int32) , DIMENSION(maxpos)  ::  disks
      END TYPE stack
!
! Local variables
!
      INTEGER  ::  last_move              ! Holds the destination of the last move
      end module data_defs
