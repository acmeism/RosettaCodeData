# No arguments
funcdecl f0 .
#
# Two arguments
procdecl f1 a s$ .
#
# Varargs are not available
#
# Two arguments (integer and string), pass by reference
procdecl f4 &a &s$ .
#
# Function returning an array
funcdecl[] f7 .
#
print f0
#
# Each declared function must also be implemented
#
func f0 .
   return 3
.
proc f1 a s$ .
   print s$ & a
.
proc f4 &a &s$ .
   a = 7
   s$ = "hello"
.
func[] f7 .
   return [ 1 2 3 ]
.
