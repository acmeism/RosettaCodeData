      INTEGER FUNCTION FINDI(X,A,N)	!Binary chopper. Find i such that X = A(i)
Careful: it is surprisingly difficult to make this neat, due to vexations when N = 0 or 1.
       REAL X,A(*)		!Where is X in array A(1:N)?
       INTEGER N		!The count.
       INTEGER L,R,P		!Fingers.
        L = 0			!Establish outer bounds, to search A(L+1:R-1).
        R = N + 1		!L = first - 1; R = last + 1.
    1   P = (R - L)/2		!Probe point. Beware INTEGER overflow with (L + R)/2.
        IF (P.LE.0) GO TO 5	!Aha! Nowhere!! The span is empty.
        P = P + L		!Convert an offset from L to an array index.
        IF (X - A(P)) 3,4,2	!Compare to the probe point.
    2   L = P			!A(P) < X. Shift the left bound up: X follows A(P).
        GO TO 1			!Another chop.
    3   R = P			!X < A(P). Shift the right bound down: X precedes A(P).
        GO TO 1			!Try again.
    4   FINDI = P		!A(P) = X. So, X is found, here!
       RETURN			!Done.
Curse it!
    5   FINDI = -L		!X is not found. Insert it at L + 1, i.e. at A(1 - FINDI).
      END FUNCTION FINDI	!A's values need not be all different, merely in order.
