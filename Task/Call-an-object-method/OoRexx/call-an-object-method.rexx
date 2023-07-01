say "pi:" .circle~pi
c=.circle~new(1)
say "c~area:" c~area
Do r=2 To 10
 c.r=.circle~new(r)
 End
say .circle~instances('') 'circles were created'

::class circle
::method pi class -- a class method
  return 3.14159265358979323

::method instances class -- another class method
  expose in
  use arg a
  If datatype(in)<>'NUM' Then in=0
  If a<>'' Then
    in+=1
  Return in

::method init
  expose radius
  use arg radius
  self~class~instances('x')

::method area     -- an instance method
  expose radius
  Say self~class
  Say self
  return self~class~pi * radius * radius
