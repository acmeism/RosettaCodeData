delegator = .delegator~new   -- no delegate
say delegator~operation
-- an invalid delegate type
delegator~delegate = "Some string"
say delegator~operation
-- a good delegate
delegator~delegate = .thing~new
say delegator~operation
-- a directory object with a thing entry defined
d = .directory~new
d~thing = "delegate implementation"
delegator~delegate = d
say delegator~operation

-- a class we can use as a delegate
::class thing
::method thing
  return "delegate implementation"

::class delegator
::method init
  expose delegate
  use strict arg delegate = .nil

::attribute delegate

::method operation
  expose delegate
  if delegate == .nil then return "default implementation"

  -- Note:  We could use delegate~hasMethod("THING") to check
  -- for a THING method, but this will fail of the object relies
  -- on an UNKNOWN method to handle the method.  By trapping
  -- NOMETHOD conditions, we can allow those calls to go
  -- through
  signal on nomethod
  return delegate~thing

nomethod:
  return "default implementation"
