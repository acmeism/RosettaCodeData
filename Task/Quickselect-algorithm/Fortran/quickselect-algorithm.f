      INTEGER FUNCTION FINDELEMENT(K,A,N)	!I know I can.
Chase an order statistic: FindElement(N/2,A,N) leads to the median, with some odd/even caution.
Careful! The array is shuffled: for i < K, A(i) <= A(K); for i > K, A(i) >= A(K).
Charles Anthony Richard Hoare devised this method, as related to his famous QuickSort.
       INTEGER K,N		!Find the K'th element in order of an array of N elements, not necessarily in order.
       INTEGER A(N),HOPE,PESTY	!The array, and like associates.
       INTEGER L,R,L2,R2	!Fingers.
        L = 1			!Here we go.
        R = N			!The bounds of the work area within which the K'th element lurks.
        DO WHILE (L .LT. R)	!So, keep going until it is clamped.
          HOPE = A(K)		!If array A is sorted, this will be rewarded.
          L2 = L		!But it probably isn't sorted.
          R2 = R		!So prepare a scan.
          DO WHILE (L2 .LE. R2)	!Keep squeezing until the inner teeth meet.
            DO WHILE (A(L2) .LT. HOPE)	!Pass elements less than HOPE.
              L2 = L2 + 1		!Note that at least element A(K) equals HOPE.
            END DO			!Raising the lower jaw.
            DO WHILE (HOPE .LT. A(R2))	!Elements higher than HOPE
              R2 = R2 - 1		!Are in the desired place.
            END DO			!And so we speed past them.
            IF (L2 - R2) 1,2,3	!How have the teeth paused?
    1       PESTY = A(L2)		!On grit. A(L2) > HOPE and A(R2) < HOPE.
            A(L2) = A(R2)		!So swap the two troublemakers.
            A(R2) = PESTY		!To be as if they had been in the desired order all along.
    2       L2 = L2 + 1		!Advance my teeth.
            R2 = R2 - 1		!As if they hadn't paused on this pest.
    3     END DO		!And resume the squeeze, hopefully closing in K.
          IF (R2 .LT. K) L = L2	!The end point gives the order position of value HOPE.
          IF (K .LT. L2) R = R2	!But we want the value of order position K.
        END DO			!Have my teeth met yet?
        FINDELEMENT = A(K)	!Yes. A(K) now has the K'th element in order.
      END FUNCTION FINDELEMENT	!Remember! Array A has likely had some elements moved!

      PROGRAM POKE
      INTEGER FINDELEMENT	!Not the default type for F.
      INTEGER N			!The number of elements.
      PARAMETER (N = 10)	!Fixed for the test problem.
      INTEGER A(66)		!An array of integers.
      DATA A(1:N)/9, 8, 7, 6, 5, 0, 1, 2, 3, 4/	!The specified values.

      WRITE (6,1) A(1:N)	!Announce, and add a heading.
    1 FORMAT ("Selection of the i'th element in order from an array.",/
     1 "The array need not be in order, and may be reordered.",/
     2 "  i Val:Array elements...",/,8X,666I2)

      DO I = 1,N	!One by one,
        WRITE (6,2) I,FINDELEMENT(I,A,N),A(1:N)	!Request the i'th element.
    2   FORMAT (I3,I4,":",666I2)	!Match FORMAT 1.
      END DO		!On to the next trial.

      END	!That was easy.
