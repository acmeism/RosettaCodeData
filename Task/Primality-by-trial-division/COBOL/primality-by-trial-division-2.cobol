Identification division.
Program-id. prime-by-div-main.

Data division.
Working-storage section.
01 num-out pic z(10).
01 num pic 9(10).
01 ans pic x.
    88 is-prime value "y".

Procedure division.
Main.
Perform until 1 = 2
    display "Number: " with no advancing
    accept num
    move num to num-out
    if num = 0 stop run end-if
    call "prime-by-div-subr" using num by reference ans
    if ans = "Y" display num-out " is prime."
    else display num-out " is not prime."
end-perform.
Stop run.
