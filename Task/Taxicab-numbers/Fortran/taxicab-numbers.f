! A non-bruteforce approach
     PROGRAM POOKA
      IMPLICIT NONE
!
! PARAMETER definitions
!
      INTEGER , PARAMETER  ::  NVARS = 25
!
! Local variables
!
      REAL  ::  f1
      REAL  ::  f2
      INTEGER  ::  hits
      INTEGER  ::  s
      INTEGER  ::  TAXICAB

      hits = 0
      s = 0
      f1 = SECOND()
      DO WHILE ( hits<NVARS )
         s = s + 1
         hits = hits + TAXICAB(s)
      END DO
      f2 = SECOND()
      PRINT * , 'elapsed time = ' , f2 - f1 , 'For ' , NVARS , ' Variables'
      STOP
      END PROGRAM POOKA

      FUNCTION TAXICAB(N)
      IMPLICIT NONE
!
! Dummy arguments
!
      INTEGER  ::  N
      INTEGER  ::  TAXICAB
      INTENT (IN) N
!
! Local variables
!
      INTEGER  ::  holder
      INTEGER  ::  oldx
      INTEGER  ::  oldy
      INTEGER  ::  s
      INTEGER  ::  x
      INTEGER  ::  y
      real*8,parameter :: xpon=(1.0D0/3.0D0)
!
      x = 0
      holder = 0
      oldx = 0
      oldy = 0
      TAXICAB = 0
      y = INT(N**xpon)
      DO WHILE ( x<=y )
         s = x**3 + y**3
         IF( s<N )THEN
            x = x + 1
         ELSE IF( s>N )THEN
            y = y - 1
         ELSE
            IF( holder==s )THEN ! Print the last value and this one that correspond
               WRITE(6 , 34)s , '(' , x**3 , y**3 , ')' , '(' , oldx**3 , oldy**3 , ')'
 34            FORMAT(1x , i12 , 10x , 1A1 , i12 , 2x , i12 , 1A1 , 10x , 1A1 , i12 , 2x ,&
                    & i12 , 1A1)
               TAXICAB = 1  ! Indicate that we found a Taxi Number
            END IF
            holder = s      ! Set to the number that appears a potential cab number
            oldx = x       ! Retain the values for the 2 cubes
            oldy = y
            x = x + 1       ! Keep looking
            y = y - 1
         END IF
      END DO
      RETURN
      END FUNCTION TAXICAB
