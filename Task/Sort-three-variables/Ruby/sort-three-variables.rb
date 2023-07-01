x =  'lions, tigers, and'
y =  'bears, oh my!'
z =  '(from the "Wizard of OZ")'
x, y, z = [x, y, z].sort
puts x, y, z

x, y, z = 7.7444e4, -12, 18/2r # Float, Integer, Rational; taken from Raku
x, y, z = [x, y, z].sort
puts x, y, z
