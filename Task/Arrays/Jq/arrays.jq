# Create a new array with length 0
[]

# Create a new array of 5 nulls
[][4] = null   # setting the element at offset 4 expands the array

# Create an array having the elements 1 and 2 in that order
[1,2]

# Create an array of integers from 0 to 10 inclusive
[ range(0; 11) ]

# If a is an array (of any length), update it so that a[2] is 5
a[2] = 5;

# Append arrays a and b
a + b

# Append an element, e, to an array a
a + [e]

##################################################
# In the following, a is assumed to be [0,1,2,3,4]

# It is not an error to use an out-of-range index:
a[10]  # => null

# Negative indices count backwards from after the last element:
a[-1]  # => 4

# jq supports simple slice operations but
# only in the forward direction:
a[:1]  # => [0]
a[1:]  # => [1,2,3,4]
a[2:4] # => [2,3]
a[4:2] # null
