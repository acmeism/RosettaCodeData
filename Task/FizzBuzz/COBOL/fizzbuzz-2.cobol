Identification division.
Program-id. fizz-buzz.

Data division.
Working-storage section.

01 num pic 999.

Procedure division.
    Perform varying num from 1 by 1 until num > 100
        if function mod (num, 15) = 0 then display "fizzbuzz"
        else if function mod (num, 3) = 0 then display "fizz"
        else if function mod (num, 5) = 0 then display "buzz"
        else display num
    end-perform.
    Stop run.
