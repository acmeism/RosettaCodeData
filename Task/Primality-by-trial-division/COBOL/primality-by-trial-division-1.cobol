Identification division.
Program-id. prime-div.

Data division.
Working-storage section.

* The number for which we are testing primality.
01 num     pic 9(6) value 1.
01 out-num pic z(6).

* Division-related stuff.
01 div     pic 9(6).
01 div-lim pic 9(6).
01 rem     pic 9(6).
    88 not-prime value 0.

Procedure division.
Main.
    Perform until num = 0
        perform get-a-num
        perform is-prime
        move num to out-num
        if not-prime display out-num " is not prime."
        else display out-num " is prime."
    end-perform.
    Stop run.

Is-prime.
    if num < 4
        move 1 to rem
    else
        compute div-lim = function sqrt(num) + 1
        perform
            with test after
            varying div from 2 by 1
            until div = div-lim or not-prime
            compute rem = function mod(num, div)
            end-perform
    end-if.

Get-a-num.
    Display "Enter a possible prime number (0 to stop): " with no advancing.
    Accept num.
    If num = 0 stop run.
