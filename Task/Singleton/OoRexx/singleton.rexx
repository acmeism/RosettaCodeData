a = .singleton~new
b = .singleton~new

a~foo = "Rick"
if a~foo \== b~foo then say "A and B are not the same object"

::class singleton
-- initialization method for the class
::method init class
  expose singleton
  -- mark this as unallocated.  We could also just allocate
  -- the singleton now, but better practice is probably wait
  -- until it is requested
  singleton = .nil

-- override the new method.  Since this is a guarded
-- method by default, this is thread safe
::method new class
  expose singleton
  -- first request?  Do the real creation now
  if singleton == .nil then do
     -- forward to the super class.  We use this form of
     -- FORWARD rather than explicit call ~new:super because
     -- this takes care of any arguments passed to NEW as well.
     forward class(super) continue
     singleton = result
  end
  return singleton

-- an attribute that can be used to demonstrate this really is
a singleton.
::attribute foo
