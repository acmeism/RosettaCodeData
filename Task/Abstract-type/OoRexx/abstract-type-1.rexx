  -- Example showing a class that defines an interface in ooRexx
  -- shape is the interface class that defines the methods a shape instance
  -- is expected to implement as abstract methods.  Instances of the shape
  -- class need not directly subclass the interface, but can use multiple
  -- inheritance to mark itself as implementing the interface.

  r=.rectangle~new(5,2)
  say r
  -- check for instance of
  if r~isa(.shape) then say "a" r~name "is a shape"
  say "r~area:" r~area
  say

  c=.circle~new(2)
  say c
  -- check for instance of shape works even if inherited
  if c~isa(.shape) then say "a" c~name "is a shape"
  say "c~area:" c~area
  say

  -- a mixin is still a class and can be instantiated.  The abstract methods
  -- will give an error if invoked
  g=.shape~new
  say g
  say g~name
  say "g~area:" g~area -- invoking abstract method results in a runtime error.

  -- the "MIXINCLASS" tag makes this avaiable for multiple inhertance
  ::class shape MIXINCLASS Object
    ::method area abstract
    ::method name abstract

  -- directly subclassing the the interface
  ::class rectangle subclass shape

    ::method init
      expose length width
      use strict arg length=0, width=0

    ::method area
      expose length width
      return length*width

    ::method name
      return "Rectangle"

  -- inherits the shape methods
  ::class circle subclass object inherit shape

    ::method init
      expose radius
      use strict arg radius=0

    ::method area
      expose radius
      numeric digits 20
      return radius*radius*3.14159265358979323846

    ::method name
      return "Circle"
