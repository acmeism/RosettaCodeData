$ jq --run-tests < jq.tests

Testing '.' at line number 3
Testing '1+1' at line number 8
Testing '1+1' at line number 13
*** Expected 0, but got 2 for test at line number 15: 1+1
Testing 'def factorial: if . <= 0 then 1 else . * ((. - 1) | factorial) end; factorial' at line number 18
3 of 4 tests passed (0 malformed)
