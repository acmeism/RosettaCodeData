a = .vector~new(3, 4, 5);
b = .vector~new(4, 3, 5);
c = .vector~new(-5, -12, -13);

say a~dot(b)
say a~cross(b)
say a~scalarTriple(b, c)
say a~vectorTriple(b, c)


::class vector
::method init
  expose x y z
  use arg x, y, z

::attribute x get
::attribute y get
::attribute z get

-- dot product operation
::method dot
  expose x y z
  use strict arg other

  return x * other~x + y * other~y + z * other~z

-- cross product operation
::method cross
  expose x y z
  use strict arg other

  newX = y * other~z - z * other~y
  newY = z * other~x - x * other~z
  newZ = x * other~y - y * other~x
  return self~class~new(newX, newY, newZ)

-- scalar triple product
::method scalarTriple
  use strict arg vectorB, vectorC
  return self~dot(vectorB~cross(vectorC))

-- vector triple product
::method vectorTriple
  use strict arg vectorB, vectorC
  return self~cross(vectorB~cross(vectorC))

::method string
  expose x y z
  return "<"||x", "y", "z">"
