       *> -*- mode: cobol -*-
       *>
       *> I do the computations (except perhaps for the call to the
       *> "sin" function) in decimal fixed point.
       *>

       identification division.
       program-id. adaptive_simpson_task.

       data division.
       working-storage section.
       01  numer picture s9(25).  *> 25 decimal digits.
       01  denom picture s9(25).
       01  numer2 picture s9(25).
       01  a picture s9(5)V9(20). *> 5+20 decimal digits.
       01  b picture s9(5)V9(20).
       01  tol picture s9(5)V9(20).
       01  x picture s9(5)V9(20).
       01  y picture s9(5)V9(20).
       01  x0 picture s9(5)V9(20).
       01  y0 picture s9(5)V9(20).
       01  x1 picture s9(5)V9(20).
       01  y1 picture s9(5)V9(20).
       01  x2 picture s9(5)V9(20).
       01  y2 picture s9(5)V9(20).
       01  x3 picture s9(5)V9(20).
       01  y3 picture s9(5)V9(20).
       01  x4 picture s9(5)V9(20).
       01  y4 picture s9(5)V9(20).
       01  ruleval picture s9(5)V9(20).
       01  ruleval0 picture s9(5)V9(20).
       01  ruleval1 picture s9(5)V9(20).
       01  delta picture s9(5)V9(20).
       01  abs-delta picture 9(5)V9(20). *> unsigned.
       01  tol0 picture s9(5)V9(20).
       01  tol1 picture s9(5)V9(20).
       01  delta15 picture s9(5)V9(20).
       01  stepval picture s9(5)V9(20).
       01  quadval picture s9(5)V9(20).
       01  result picture -9.9(9).

       procedure division.
           move 0.0 to a
           move 1.0 to b
           move 0.000000001 to tol
           perform adaptive-quadrature
           move quadval to result
           display result
           stop run.

       adaptive-quadrature.
           move 0 to numer
           move 1 to denom
           perform until (numer = denom) and (denom = 1)
               perform get-interval
               perform simpson-rule-thrice
               compute delta = ruleval0 + ruleval1 - ruleval
               compute abs-delta = delta
               compute tol0 = tol * (x4 - x0)
               compute tol1 = tol * (x2 - x0)
               if (tol1 = tol0) or (abs-delta <= 15 * tol0) then
                   compute delta15 = delta / 15
                   compute stepval = ruleval0 + ruleval1 + delta15
                   compute quadval = quadval + stepval
                   perform go-to-next-interval
               else
                   perform bisect-current-interval
               end-if
           end-perform.

       simpson-rule-thrice.
           *> There is no attempt here to minimize the number of
           *> recomputations of sin(x).

           compute x2 = (x0 + x4) / 2
           compute x1 = (x0 + x2) / 2
           compute x3 = (x2 + x4) / 2

           compute x = x0
           perform compute-function
           compute y0 = y

           compute x = x1
           perform compute-function
           compute y1 = y

           compute x = x2
           perform compute-function
           compute y2 = y

           compute x = x3
           perform compute-function
           compute y3 = y

           compute x = x4
           perform compute-function
           compute y4 = y

           compute ruleval = ((x4 - x0) / 6) * (y0 + (4 * y2) + y4)
           compute ruleval0 = ((x2 - x0) / 6) * (y0 + (4 * y1) + y2)
           compute ruleval1 = ((x4 - x2) / 6) * (y2 + (4 * y3) + y4).

       bisect-current-interval.
           compute numer = numer + numer
           compute denom = denom + denom.

       go-to-next-interval.
           compute numer = numer + 1
           divide numer by 2 giving numer2
           if numer2 + numer2 = numer then
               perform until not (numer2 + numer2 = numer)
                   move numer2 to numer
                   divide denom by 2 giving denom
                   divide numer by 2 giving numer2
               end-perform
           end-if.

       get-interval.
           compute x0 = numer / denom
           compute x0 = (a * (1 - x0)) + (b * x0)
           compute x4 = (numer + 1) / denom
           compute x4 = (a * (1 - x4)) + (b * x4).

       compute-function.
           compute y = function sin (x).
