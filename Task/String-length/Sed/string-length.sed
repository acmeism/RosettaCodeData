# create unary numeral (i = 1)
s/./i/g
:loop
# divide by 10 (x = 10)
s/i\{10\}/x/g
# convert remainder to decimal digit
/i/!s/[0-9]*$/0&/
s/i\{9\}/9/
s/i\{8\}/8/
s/i\{7\}/7/
s/i\{6\}/6/
s/iiiii/5/
s/iiii/4/
s/iii/3/
s/ii/2/
s/i/1/
# convert quotient (10s) to 1s
y/x/i/
# start over for the next magnitude (if any)
/i/b loop
