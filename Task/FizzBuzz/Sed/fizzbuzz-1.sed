#n
# doesn't work if there's no input
# initialize counters (0 = empty) and value
s/.*/  0/
: loop
# increment counters, set carry
s/^\(a*\) \(b*\) \([0-9][0-9]*\)/\1a \2b \3@/
# propagate carry
: carry
s/ @/ 1/
s/9@/@0/
s/8@/9/
s/7@/8/
s/6@/7/
s/5@/6/
s/4@/5/
s/3@/4/
s/2@/3/
s/1@/2/
s/0@/1/
/@/b carry
# save state
h
# handle factors
s/aaa/Fizz/
s/bbbbb/Buzz/
# strip value if any factor
/z/s/[0-9]//g
# strip counters and spaces
s/[ab ]//g
# output
p
# restore state
g
# roll over counters
s/aaa//
s/bbbbb//
# loop until value = 100
/100/q
b loop
