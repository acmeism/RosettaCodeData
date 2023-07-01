set r1 to 5 ^ 3 ^ 2 -- Changes to 5 ^ (3 ^ 2) when compiled.
set r2 to (5 ^ 3) ^ 2
set r3 to 5 ^ (3 ^ 2)

return "5 ^ 3 ^ 2 = " & r1 & "
(5 ^ 3) ^ 2 = " & r2 & "
5 ^ (3 ^ 2) = " & r3
