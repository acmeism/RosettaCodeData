var # fixed size arrays
  x = [1,2,3,4,5,6,7,8,9,10] # type and size automatically inferred
  y: array[1..5, int] = [1,2,3,4,5] # starts at 1 instead of 0
  z: array['a'..'z', int] # indexed using characters

x[0] = x[1] + 1
echo x[0]
echo z['d']

x[7..9] = y[3..5] # copy part of array

var # variable size sequences
  a = @[1,2,3,4,5,6,7,8,9,10]
  b: seq[int] = @[1,2,3,4,5]

a[0] = a[1] + 1
echo a[0]

a.add(b) # append another sequence
a.add(200) # append another element
echo a.pop() # pop last item, removing and returning it
echo a
