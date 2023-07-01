!Constructs a sieve of Brazilian numbers from the definition.
!From the Algol W algorithm, somewhat "Fortranized"
      PROGRAM BRAZILIAN
      IMPLICIT NONE
!
! PARAMETER definitions
!
      INTEGER , PARAMETER  ::  MAX_NUMBER = 2000000 , NUMVARS = 20
!
! Local variables
!
      LOGICAL , DIMENSION(1:MAX_NUMBER)  ::  b
      INTEGER  ::  bcount
      INTEGER  ::  bpos
      CHARACTER(15)  ::  holder
      CHARACTER(100)  ::  outline
      LOGICAL , DIMENSION(1:MAX_NUMBER)  ::  p
!
!     find some Brazilian numbers - numbers N whose representation in some !
!     base B ( 1 < B < N-1 ) has all the same digits                       !
!     set b( 1 :: n ) to a sieve of Brazilian numbers where b( i ) is true   !
!     if i is Brazilian and false otherwise - n must be at least 8           !
!     sets p( 1 :: n ) to a sieve of primes up to n
      CALL BRAZILIANSIEVE(b , MAX_NUMBER)
      WRITE(6 , 34)"The first 20 Brazilian numbers:"
      bcount = 0
      outline = ''
      holder = ''
      bpos = 1
      DO WHILE ( bcount<NUMVARS )
         IF( b(bpos) )THEN
            bcount = bcount + 1
            WRITE(holder , *)bpos
            outline = TRIM(outline) // " " // ADJUSTL(holder)
         END IF
         bpos = bpos + 1
      END DO

      WRITE(6 , 34)outline
      WRITE(6 , 34)"The first 20 odd Brazilian numbers:"
      outline = ''
      holder = ''
      bcount = 0
      bpos = 1
      DO WHILE ( bcount<NUMVARS )
         IF( b(bpos) )THEN
            bcount = bcount + 1
            WRITE(holder , *)bpos
            outline = TRIM(outline) // " " // ADJUSTL(holder)
         END IF
         bpos = bpos + 2
      END DO
      WRITE(6 , 34)outline
      WRITE(6 , 34)"The first 20 prime Brazilian numbers:"
      CALL ERATOSTHENES(p , MAX_NUMBER)
      bcount = 0
      outline = ''
      holder = ''
      bpos = 1
      DO WHILE ( bcount<NUMVARS )
         IF( b(bpos) .AND. p(bpos) )THEN
            bcount = bcount + 1
            WRITE(holder , *)bpos
            outline = TRIM(outline) // " " // ADJUSTL(holder)
         END IF
         bpos = bpos + 1
      END DO
      WRITE(6 , 34)outline
      WRITE(6 , 34)"Various Brazilian numbers:"
      bcount = 0
      bpos = 1
      DO WHILE ( bcount<1000000 )
         IF( b(bpos) )THEN
            bcount = bcount + 1
            IF( (bcount==100) .OR. (bcount==1000) .OR. (bcount==10000) .OR.               &
              & (bcount==100000) .OR. (bcount==1000000) )WRITE(* , *)bcount ,             &
               &"th Brazilian number: " , bpos
         END IF
         bpos = bpos + 1
      END DO
      STOP
 34   FORMAT(/ , a)
      END PROGRAM BRAZILIAN
!
      SUBROUTINE BRAZILIANSIEVE(B , N)
      IMPLICIT NONE
!
! Dummy arguments
!
      INTEGER  ::  N
      LOGICAL , DIMENSION(*)  ::  B
      INTENT (IN) N
      INTENT (OUT) B
!
! Local variables
!
      INTEGER  ::  b11
      INTEGER  ::  base
      INTEGER  ::  bn
      INTEGER  ::  bnn
      INTEGER  ::  bpower
      INTEGER  ::  digit
      INTEGER  ::  i
      LOGICAL  ::  iseven
      INTEGER  ::  powermax
!
      iseven = .FALSE.
      B(1:6) = .FALSE.                 ! numbers below 7 are not Brazilian (see task notes)
      DO i = 7 , N
         B(i) = iseven
         iseven = .NOT.iseven
      END DO
      DO base = 2 , (N/2)
         b11 = base + 1
         bnn = b11
         DO digit = 3 , base - 1 , 2
            bnn = bnn + b11 + b11
            IF( bnn>N )EXIT
            B(bnn) = .TRUE.
         END DO
      END DO
      DO base = 2 , INT(SQRT(FLOAT(N)))
         powermax = HUGE(powermax)/base             ! avoid 32 bit     !
         IF( powermax>N )powermax = N               ! integer overflow !
         DO digit = 1 , base - 1 , 2
            bpower = base*base
            bn = digit*(bpower + base + 1)
            DO WHILE ( (bn<=N) .AND. (bpower<=powermax) )
               IF( bn<=N )B(bn) = .TRUE.
               bpower = bpower*base
               bn = bn + (digit*bpower)
            END DO
         END DO
      END DO
      RETURN
      END SUBROUTINE BRAZILIANSIEVE
!
      SUBROUTINE ERATOSTHENES(P , N)
      IMPLICIT NONE
!
! Dummy arguments
!
      INTEGER  ::  N
      LOGICAL , DIMENSION(*)  ::  P
      INTENT (IN) N
      INTENT (INOUT) P
!
! Local variables
!
      INTEGER  ::  i
      INTEGER  ::  ii
      LOGICAL  ::  oddeven
      INTEGER  ::  pr
!
      P(1) = .FALSE.
      P(2) = .TRUE.
      oddeven = .TRUE.
      DO i = 3 , N
         P(i) = oddeven
         oddeven = .NOT.oddeven
      END DO
      DO i = 2 , INT(SQRT(FLOAT(N)))
         ii = i + i
         IF( P(i) )THEN
            DO pr = i*i , N , ii
               P(pr) = .FALSE.
            END DO
         END IF
      END DO
      RETURN
      END SUBROUTINE ERATOSTHENES
