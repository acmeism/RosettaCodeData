***********************************************************************
* KMPP - K-Means++ - Traditional data clustering with a special initialization
* Public Domain - This program may be used by any person for any purpose.
*
* Origin:
*    Hugo Steinhaus, 1956
*
* Refer to:
*    "kmeans++: the advantages of careful seeding"
*    David Arthur and Sergei Vassilvitskii
*    Proceedings of the eighteenth annual ACM-SIAM symposium
*      on Discrete algorithms, 2007
*
*____Variable_______I/O_______Description___________________Type_______
*    X(P,N)         In        Data points                   Real
*    P              In        Dimension of the data         Integer
*    N              In        Number of points              Integer
*    K              In        # clusters                    Integer
*    C(P,K)         Out       Center points of clusters     Real
*    Z(N)           Out       What cluster a point is in    Integer
*    WORK(N)        Neither                                 Real
*    IFAULT         Out       Error code                    Integer
************************************************************************
      SUBROUTINE KMPP (X, P, N, K, C, Z, WORK, IFAULT)

       IMPLICIT NONE
       INTEGER P, N, K, Z, IFAULT
       REAL X, C, WORK
       DIMENSION X(P,N), C(P,K), Z(N), WORK(N)

*               constants
       INTEGER ITER                 ! maximum iterations
       REAL BIG                     ! arbitrary large number
       PARAMETER (ITER = 1000,
     $            BIG = 1E33)

*                local variables
       INTEGER
     $         H,          ! count iterations
     $         I,          ! count points
     $         I1,         ! point marked as initial center
     $         J,          ! count dimensions
     $         L,          ! count clusters
     $         L0,         ! present cluster ID
     $         L1          ! new cluster ID

       REAL
     $      BEST,                 ! shortest distance to a center
     $      D2,                   ! squared distance
     $      TOT,                  ! a total
     $      W                     ! temp scalar

       LOGICAL CHANGE             ! whether any points have been reassigned

************************************************************************
*           Begin.
************************************************************************
       IFAULT = 0
       IF (K < 1 .OR. K > N) THEN       ! K out of bounds
         IFAULT = 3
         RETURN
       END IF
       DO I = 1, N                       ! clear Z
         Z(I) = 0
       END DO

************************************************************************
*        initial centers
************************************************************************
       DO I = 1, N
         WORK(I) = BIG
       END DO

       CALL RANDOM_NUMBER (W)
       I1 = MIN(INT(W * FLOAT(N)) + 1, N)  ! choose first center at random
       DO J = 1, P
         C(J,1) = X(J,I1)
       END DO

       DO L = 2, K                    ! initialize other centers
         TOT = 0.
         DO I = 1, N                     ! measure from each point
           BEST = WORK(I)
           D2 = 0.                         ! to prior center
           DO J = 1, P
             D2 = D2 + (X(J,I) - C(J,L-1)) **2  ! Squared Euclidean distance
             IF (D2 .GE. BEST) GO TO 10               ! needless to add to D2
           END DO                          ! next J
           IF (D2 < BEST) BEST = D2          ! shortest squared distance
           WORK(I) = BEST
  10       TOT = TOT + BEST             ! cumulative squared distance
         END DO                      ! next data point

************************************************************************
* Choose center with probability proportional to its squared distance
*     from existing centers.
************************************************************************
         CALL RANDOM_NUMBER (W)
         W = W * TOT    ! uniform at random over cumulative distance
         TOT = 0.
         DO I = 1, N
           I1 = I
           TOT = TOT + WORK(I)
           IF (TOT > W) GO TO 20
         END DO                ! next I
  20     CONTINUE
         DO J = 1, P         ! assign center
           C(J,L) = X(J,I1)
         END DO
       END DO               ! next center to initialize

************************************************************************
*                      main loop
************************************************************************
       DO H = 1, ITER
         CHANGE = .FALSE.

*             find nearest center for each point
         DO I = 1, N
           L0 = Z(I)
           L1 = 0
           BEST = BIG
           DO L = 1, K
             D2 = 0.
             DO J = 1, P
               D2 = D2 + (X(J,I) - C(J,L)) **2
               IF (D2 .GE. BEST) GO TO 30
             END DO
  30         CONTINUE
             IF (D2 < BEST) THEN           ! new nearest center
               BEST = D2
               L1 = L
             END IF
           END DO        ! next L

           IF (L0 .NE. L1) THEN
             Z(I) = L1                   !  reassign point
             CHANGE = .TRUE.
           END IF
         END DO         ! next I
         IF (.NOT. CHANGE) RETURN      ! success

************************************************************************
*           find cluster centers
************************************************************************
         DO L = 1, K              ! zero population
           WORK(L) = 0.
         END DO
         DO L = 1, K               ! zero centers
           DO J = 1, P
             C(J,L) = 0.
           END DO
         END DO

         DO I = 1, N
           L = Z(I)
           WORK(L) = WORK(L) + 1.             ! count
           DO J = 1, P
             C(J,L) = C(J,L) + X(J,I)         ! add
           END DO
         END DO

         DO L = 1, K
           IF (WORK(L) < 0.5) THEN          ! empty cluster check
             IFAULT = 1                     ! fatal error
             RETURN
           END IF
           W = 1. / WORK(L)
           DO J = 1, P
             C(J,L) = C(J,L) * W     ! multiplication is faster than division
           END DO
         END DO

       END DO                   ! next H
       IFAULT = 2                ! too many iterations
       RETURN

      END  ! of KMPP


************************************************************************
*             test program (extra credit #1)
************************************************************************
      PROGRAM TPEC1
       IMPLICIT NONE
       INTEGER N, P, K
       REAL TWOPI
       PARAMETER (N = 30 000,
     $            P = 2,
     $            K = 6,
     $            TWOPI = 6.2831853)
       INTEGER I, L, Z(N), IFAULT
       REAL X(P,N), C(P,K), R, THETA, W, WORK(N)

*             Begin
       CALL RANDOM_SEED()
       DO I = 1, N                      ! random points over unit circle
         CALL RANDOM_NUMBER (W)
         R = SQRT(W)                      ! radius
         CALL RANDOM_NUMBER (W)
         THETA = W * TWOPI                ! angle
         X(1,I) = R * COS(THETA)          ! Cartesian coordinates
         X(2,I) = R * SIN(THETA)
       END DO

*             Call subroutine
       CALL KMPP (X, P, N, K, C, Z, WORK, IFAULT)
       PRINT *, 'kmpp returns with error code ', IFAULT

*            Print lists of points in each cluster
       DO L = 1, K
         PRINT *, 'Cluster ', L, ' contains points: '
  10     FORMAT (I6, $)
  20     FORMAT ()
         DO I = 1, N
           IF (Z(I) .EQ. L) PRINT 10, I
         END DO
         PRINT 20
       END DO

*         Write CSV file with Y-coordinates in different columns by cluster
       OPEN (UNIT=1, FILE='tpec1.csv', STATUS='NEW', IOSTAT=IFAULT)
       IF (IFAULT .NE. 0) PRINT *, 'tpec1: trouble opening file'
  30   FORMAT (F8.4, $)
  40   FORMAT (',', $)
  50   FORMAT (F8.4)
       DO I = 1, N
         WRITE (UNIT=1, FMT=30, IOSTAT=IFAULT) X(1,I)
         IF (IFAULT .NE. 0) PRINT *, 'tpec1: trouble writing X-coord'
         DO L = 1, Z(I)                     ! one comma per cluster ID
           WRITE (UNIT=1, FMT=40, IOSTAT=IFAULT)
           IF (IFAULT .NE. 0) PRINT *, 'tpec1: trouble writing comma'
         END DO
         WRITE (UNIT=1, FMT=50, IOSTAT=IFAULT) X(2,I)
         IF (IFAULT .NE. 0) PRINT *, 'tpec1: trouble writing Y-coord'
       END DO

*           Write the centroids in the far column
       DO L = 1, K
         WRITE (UNIT=1, FMT=30, IOSTAT=IFAULT) C(1,L)
         IF (IFAULT .NE. 0) PRINT *, 'tpec1: trouble writing X-coord'
         DO I = 1, K+1
           WRITE (UNIT=1, FMT=40, IOSTAT=IFAULT)
           IF (IFAULT .NE. 0) PRINT *, 'tpec1: trouble writing comma'
         END DO
         WRITE (UNIT=1, FMT=50, IOSTAT=IFAULT) C(2,L)
         IF (IFAULT .NE. 0) PRINT *, 'tpec1: trouble writing Y-coord'
       END DO
       CLOSE (UNIT=1)

      END  ! of test program
