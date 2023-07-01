Identification division.
Program-id. three-five-sum.

Data division.
Working-storage section.
01 ws-the-limit  pic 9(18) value 1000.
01 ws-the-number pic 9(18).
01 ws-the-sum    pic 9(18).
01 ws-sum-out    pic z(18).

Procedure division.
Main-program.
    Perform Do-sum
        varying ws-the-number from 1 by 1
        until ws-the-number = ws-the-limit.
    Move ws-the-sum to ws-sum-out.
    Display "Sum = " ws-sum-out.
    End-run.

Do-sum.
    If function mod(ws-the-number, 3) = zero
       or function mod(ws-the-number, 5) = zero
       then add ws-the-number to ws-the-sum.
