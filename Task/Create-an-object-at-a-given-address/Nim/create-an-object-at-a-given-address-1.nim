type
  MyObject = object
    x: int
    y: float

var
  mem = alloc(sizeof(MyObject))
  objPtr = cast[ptr MyObject](mem)
echo "object at ", cast[int](mem), ": ", objPtr[]

objPtr[] = MyObject(x: 42, y: 3.1415)
echo "object at ", cast[int](mem), ": ", objPtr[]
