      MODULE BIGNUMBERVB	!Limited services: integers, no negative numbers, variable base possible.
       INTEGER BIGORDER		!A limited attempt at generality.
       PARAMETER (BIGORDER = 1)	!This is the order of the base of the big number arithmetic.
       INTEGER BIGBASE,BIGLIMIT	!Sized thusly.
c       PARAMETER (BIGBASE = 10**BIGORDER, BIGLIMIT = 8888/BIGORDER)	!Enough?
       PARAMETER (BIGLIMIT = 666)
       TYPE BIGNUM	!So, a big number is simple.
        INTEGER LAST		!This many digits (of size BIGBASE) are in use.
        INTEGER DIGIT(BIGLIMIT)	!The digits, in ascending power order.
       END TYPE BIGNUM	!So much for that.
