       >>source format is free
identification division.
program-id. prime-div.

data division.
working-storage section.

*> The number for which we are testing primality.
01 num     pic 9(6) value 1.
01 out-num pic z(6).

*> Division-related stuff.
01 div     pic 9(6).
01 div-lim pic 9(6).
01 rem     pic 9(6).
    88 not-prime value 0.

procedure division.
main.
    perform until num = 0
        perform get-a-num
        perform is-prime
        move num to out-num
        if not-prime
            display out-num " is not prime."
        else
            display out-num " is prime."
        end-if
    end-perform

    stop run
    .

is-prime.
    if num = 1
        move 0 to rem
    else if num < 4
        move 1 to rem
    else
        compute div-lim = function sqrt(num) + 1
        perform with test after varying div from 2 by 1
                until (div = div-lim) or not-prime
            compute rem = function mod(num, div)
        end-perform
    end-if
    .

get-a-num.
    display "Enter a possible prime number (0 to stop): " with no advancing
    accept num
    if num = 0
        stop run
    end-if
    .
