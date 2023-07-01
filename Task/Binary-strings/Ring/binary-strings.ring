# string creation
x = "hello world"

# string destruction
x = NULL

# string assignment with a null byte
x = "a"+char(0)+"b"
see len(x)  # ==> 3

# string comparison
if x = "hello"
  See "equal"
else
  See "not equal"
ok
y = 'bc'
if strcmp(x,y) < 0
  See x + " is lexicographically less than " + y
ok

# string cloning
xx = x
See x = xx       # true, same length and content

# check if empty
if x = NULL
  See "is empty"
ok

# append a byte
x += char(7)

# substring
x = "hello"
x[1] = "H"
See x + nl

# join strings
a = "hel"
b = "lo w"
c = "orld"
See a + b + c
