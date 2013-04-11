Identification division.
Program-id. prime-by-div-subr.

Data division.
Working-storage section.
01 div pic 9(10).
01 lim pic 9(10).
01 rem pic 9(10).
    88 is-not-prime value 0.

Linkage section.
01 the-num pic 9(10).
01 the-ans pic x.

Procedure division using the-num, the-ans.
Main.
Move "Y" to the-ans.
If the-num < 4 exit program.
Compute lim = Function sqrt(the-num) + 1.
Perform
    with test after
    varying div from 2 by 1
    until div > lim or is-not-prime
    compute rem = function mod(the-num, div)
end-perform.
If is-not-prime move "N" to the-ans.
Exit program.
