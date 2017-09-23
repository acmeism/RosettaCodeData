d = .dynamicvar~new
d~foo = 123
say d~foo

-- a class that allows dynamic variables.  Since this is a mixin, this
-- capability can be added to any class using multiple inheritance
::class dynamicvar MIXINCLASS object
::method init
  expose variables
  variables = .directory~new

-- the unknown method will get invoked any time an unknown method is
-- used.  This UNKNOWN method will add attribute methods for the given
-- name that will be available on all subsequent uses.
::method unknown
  expose variables
  use strict arg messageName, arguments

  -- check for an assignment or fetch, and get the proper
  -- method name
  if messageName~right(1) == '=' then do
     variableName = messageName~left(messageName~length - 1)
  end
  else do
     variableName = messageName
  end

  -- define a pair of methods to set and retrieve the instance variable.  These are
  -- created at the object scope
  self~setMethod(variableName, 'expose' variableName'; return' variableName)
  self~setMethod(variableName'=', 'expose' variableName'; use strict arg value;' variableName '= value' )

  -- reinvoke the original message.  This will now go to the dynamically added
  methods
  forward to(self) message(messageName) arguments(arguments)
