# Test case 1:
.
1
1

# Test case 2:
1+1
null
2

# Test case 3 (with the wrong result):
1+1
null
0

# A test case with a function definition:
def factorial: if . <= 0 then 1 else . * ((. - 1) | factorial) end; factorial
3
6
