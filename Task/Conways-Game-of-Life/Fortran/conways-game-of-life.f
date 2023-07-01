 PROGRAM LIFE_2D
   IMPLICIT NONE

   INTEGER, PARAMETER :: gridsize = 10
   LOGICAL :: cells(0:gridsize+1,0:gridsize+1) = .FALSE.
   INTEGER :: i, j, generation=0
   REAL :: rnums(gridsize,gridsize)

 !  Start patterns
 !  **************
 !  cells(2,1:3) = .TRUE.                                                  ! Blinker
 !  cells(3,4:6) = .TRUE. ; cells(4,3:5) = .TRUE.                          ! Toad
 !  cells(1,2) = .TRUE. ; cells(2,3) = .TRUE. ; cells(3,1:3) = .TRUE.      ! Glider
    cells(3:5,3:5) = .TRUE. ; cells(6:8,6:8) = .TRUE.                      ! Figure of Eight
 !  CALL RANDOM_SEED
 !  CALL RANDOM_NUMBER(rnums)
 !  WHERE (rnums>0.6) cells(1:gridsize,1:gridsize) = .TRUE.                ! Random universe

   CALL Drawgen(cells(1:gridsize, 1:gridsize), generation)
   DO generation = 1, 8
      CALL NextgenV2(cells)
      CALL Drawgen(cells(1:gridsize, 1:gridsize), generation)
   END DO

 CONTAINS

   SUBROUTINE Drawgen(cells, gen)
     LOGICAL, INTENT(IN OUT) :: cells(:,:)
     INTEGER, INTENT(IN) :: gen

     WRITE(*, "(A,I0)") "Generation ", gen
     DO i = 1, SIZE(cells,1)
        DO j = 1, SIZE(cells,2)
           IF (cells(i,j)) THEN
              WRITE(*, "(A)", ADVANCE = "NO") "#"
           ELSE
              WRITE(*, "(A)", ADVANCE = "NO") " "
           END IF
        END DO
        WRITE(*,*)
     END DO
     WRITE(*,*)
   END SUBROUTINE Drawgen

  SUBROUTINE Nextgen(cells)
     LOGICAL, INTENT(IN OUT) :: cells(0:,0:)
     LOGICAL :: buffer(0:SIZE(cells, 1)-1, 0:SIZE(cells, 2)-1)
     INTEGER :: neighbours, i, j

     buffer = cells   ! Store current status
     DO j = 1, SIZE(cells, 2)-2
        DO i = 1, SIZE(cells, 1)-2
          if(buffer(i, j)) then
            neighbours = sum(count(buffer(i-1:i+1, j-1:j+1), 1)) - 1
          else
            neighbours = sum(count(buffer(i-1:i+1, j-1:j+1), 1))
          end if

          SELECT CASE(neighbours)
            CASE (0:1, 4:8)
               cells(i,j) = .FALSE.

            CASE (2)
               ! No change

            CASE (3)
               cells(i,j) = .TRUE.
          END SELECT

        END DO
     END DO
  END SUBROUTINE Nextgen

!###########################################################################
!   In this version instead of cycling through all points an integer array
! is used the sum the live neighbors of all points. The sum is done with
! the entire array cycling through the eight positions of the neighbors.
!   Executing a grid size of 10000 in 500 generations this version gave a
! speedup of almost 4 times.
!###########################################################################
  PURE SUBROUTINE NextgenV2(cells)
     LOGICAL, INTENT(IN OUT) :: cells(:,:)
     INTEGER(KIND=1) :: buffer(1:SIZE(cells, 1)-2,1:SIZE(cells, 2)-2)
     INTEGER :: gridsize, i, j

     gridsize=SIZE(cells, 1)
     buffer=0

     DO j=-1, 1
        DO i=-1,1
           IF(i==0 .AND. j==0) CYCLE
           WHERE(cells(i+2:gridsize-i-1,j+2:gridsize-j-1)) buffer=buffer+1
        END DO
     END DO

     WHERE(buffer<2 .or. buffer>3) cells(2:gridsize-1,2:gridsize-1) = .FALSE.
     WHERE(buffer==3) cells(2:gridsize-1,2:gridsize-1) = .TRUE.
  END SUBROUTINE NextgenV2
!###########################################################################
 END PROGRAM LIFE_2D
