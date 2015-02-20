Identification division.
Program-id. three-five-sum-fast.

Data division.
Working-storage section.
01 ws-num     pic 9(18) value 1000000000.
01 ws-n5      pic 9(18).
01 ws-n3      pic 9(18).
01 ws-n15     pic 9(18).
01 ws-sum     pic 9(18).
01 ws-out.
    02 ws-out-num pic z(18).
    02 filler pic x(3) value " = ".
    02 ws-out-sum pic z(18).

Procedure division.
Main-program.
    Perform
        call "tri-sum" using ws-num 3  by reference ws-n3
        call "tri-sum" using ws-num 5  by reference ws-n5
        call "tri-sum" using ws-num 15  by reference ws-n15
    end-perform.
    Compute ws-sum = ws-n3 + ws-n5 - ws-n15.
    Move ws-sum to ws-out-sum.
    Move ws-num to ws-out-num.
    Display ws-out.



Identification division.
Program-id. tri-sum.

Data division.
Working-storage section.
01 ws-n1 pic 9(18).
01 ws-n2 pic 9(18).

Linkage section.
77 ls-num pic 9(18).
77 ls-fac pic 9(18).
77 ls-ret pic 9(18).

Procedure division using ls-num, ls-fac, ls-ret.
    Compute ws-n1 = (ls-num - 1) / ls-fac.
    Compute ws-n2 = ws-n1 + 1.
    Compute ls-ret = ls-fac * ws-n1 * ws-n2 / 2.
    goback.
