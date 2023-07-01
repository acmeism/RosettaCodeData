      PROGRAM SUNDARAM
      IMPLICIT NONE
!
! Local variables
!
      INTEGER(8)  ::  curr_index
      INTEGER(8)  ::  i
      INTEGER(8)  ::  j
      INTEGER  ::  lim
      INTEGER(8)  ::  mid
      INTEGER  ::  primcount
      LOGICAL*1 , ALLOCATABLE , DIMENSION(:)  ::  primes !Array of booleans representing integers
      lim = 10000000 ! Not the number of primes but the storage where the prime marker is held for the millionth prime
      ALLOCATE(primes(lim))
      primes(1:lim) = .TRUE.
                        !Set all to .True., we will later block out the known non-primes
      mid = lim/2

!Generate primes
      DO j = 1 , mid
         DO i = 1 , j
            curr_index = i + j + (2*i*j)
            IF( curr_index>lim )EXIT        ! Too big already, leave the loop.
            primes(curr_index) = .FALSE.    !This candidate will not produce a prime
         END DO
      END DO
!
      i = 0
      j = 0
      WRITE(6 , *)'The first 100 primes:'
      DO WHILE ( i < 100 )
         j = j + 1
         IF( primes(j) )THEN
            WRITE(6 , 34 , ADVANCE = 'no')j*2 + 1   !Take the candidate, multiply by 2, add 1, and you have a prime
 34         FORMAT(I0 , 1x)
            i = i + 1                       ! Counter used for printing
            IF( MOD(i,10)==0 )WRITE(6 , *)' '
         END IF
      END DO
! Now print the millionth prime
      primcount = 0
      DO i = 1 , lim
         IF( primes(i) )THEN
            primcount = primcount + 1
            IF( primcount==1000000 )THEN
               WRITE(6 , 35)'1 millionth Prime Found: ' , (i*2) + 1
 35            FORMAT(/ , a , i0)
               EXIT
            END IF
         END IF
      END DO
      DEALLOCATE(primes)
      STOP
      END PROGRAM SUNDARAM
