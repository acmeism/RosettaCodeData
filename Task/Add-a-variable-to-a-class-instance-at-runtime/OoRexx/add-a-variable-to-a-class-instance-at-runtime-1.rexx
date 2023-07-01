d = .dynamicvar~new
d~foo = 123
say d~foo

d2 = .dynamicvar2~new
d~bar = "Fred"
say d~bar

-- a class that allows dynamic variables.  Since this is a mixin, this
-- capability can be added to any class using multiple inheritance
::class dynamicvar MIXINCLASS object
::method init
  expose variables
  variables = .directory~new

-- the UNKNOWN method is invoked for all unknown messages.  We turn this
-- into either an assignment or a retrieval for the desired item
::method unknown
  expose variables
  use strict arg messageName, arguments

  -- assignment messages end with '=', which tells us what to do
  if messageName~right(1) == '=' then do
     variables[messageName~left(messageName~length - 1)] = arguments[1]
  end
  else do
      return variables[messageName]
  end


-- this class is not a direct subclass of dynamicvar, but mixes in the
-- functionality using multiple inheritance
::class dynamicvar2 inherit dynamicvar
::method init
  -- mixin init methods are not automatically invoked, so we must
  -- explicitly invoke this
  self~init:.dynamicvar
