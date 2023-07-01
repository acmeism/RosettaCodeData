      INCLUDE 'sieve.f'

      PROGRAM RC Extensible Sieve
      IMPLICIT INTEGER (A-Z)

      WRITE (*, '(A)', advance='no')
     &   'The first 20 primes:'

      CALL nextprime(.false., p)
      DO 10, i = 1, 20
         WRITE (*, '(I3)', advance = 'no') p
10       CALL nextprime(.true., p)
      WRITE (*, *)

      WRITE (*, '(A)', advance = 'no')
     &   'The primes between 100 and 150:'

20    CALL nextprime(.true., p)
      IF (p .gt. 149) GO TO 30
      IF (p .gt. 99)
     &   WRITE (*, '(I4)', advance = 'no') p
      GO TO 20
30    WRITE (*, *)

      count = 0
40    CALL nextprime(.true., p)
      IF (p .gt. 7999) GO TO 50
      IF (p .gt. 7700) count = count + 1
      GO TO 40
50    WRITE (*, 100) count
100   FORMAT ('There are ', I0, ' primes between 7700 and 8000.')

      CALL nextprime(.false., p) ! re-initialize
      target = 1 ! target count
      n = 0 ! number of primes generated
60    n = n + 1
      IF (n .lt. target) GO TO 70
      WRITE (*, '(ES7.1,1X,I12)'), real(n), p
      IF (target .eq. 100 000 000) GO TO 80
      target = target * 10
70    CALL nextprime(.true., p)
      GO TO 60

80    END
