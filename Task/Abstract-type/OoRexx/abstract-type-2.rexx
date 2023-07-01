  -- Example showing an abstract type in ooRexx
  -- shape is the abstract class that defines the abstract method area
  -- which is then implemented by its two subclasses, rectangle and circle
  -- name is the method inherited by the subclasses.
  -- author:         Rony G. Flatscher, 2012-05-26
  -- changed/edited: Walter Pachl, 2012-05-28 28
  -- highlighting:   to come

  r=.rectangle~new(5,2)
  say r
  say r~name
  say "r~area:" r~area
  say

  c=.circle~new(2)
  say c
  say c~name
  say "c~area:" c~area
  say

  g=.shape~new
  say g
  say g~name
  say "g~area:" g~area -- invoking abstract method results in a runtime error.

  ::class shape
    ::method area abstract
    ::method name
      return "self~class~id:" self~class~id


  ::class rectangle subclass shape

    ::method init
      expose length width
      use strict arg length=0, width=0

    ::method area
      expose length width
      return length*width

  ::class circle subclass shape

    ::method init
      expose radius
      use strict arg radius=0

    ::method area
      expose radius
      numeric digits 20
      return radius*radius*3.14159265358979323846
