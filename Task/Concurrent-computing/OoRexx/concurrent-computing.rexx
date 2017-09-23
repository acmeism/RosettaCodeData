-- this will launch 3 threads, with each thread given a message to print out.
-- I've added a stoplight to make each thread wait until given a go signal,
-- plus some sleeps to give the threads a chance to randomize the execution
-- order a little.
launcher = .launcher~new
launcher~launch

::class launcher
-- the launcher method.  Guarded is the default, but let's make this
-- explicit here
::method launch guarded

  runner1 = .runner~new(self, "Enjoy")
  runner2 = .runner~new(self, "Rosetta")
  runner3 = .runner~new(self, "Code")

  -- let's give the threads a chance to settle in to the
  -- starting line
  call syssleep 1

  guard off   -- release the launcher lock.  This is the starter's gun

-- this is a guarded method that the runners will call.  They
-- will block until the launch method releases the object guard
::method block guarded

::class runner
::method init
  use arg launcher, text
  reply  -- this creates the new thread

  call syssleep .5  -- try to mix things up by sleeping
  launcher~block    -- wait for the go signal
  call syssleep .5  -- add another sleep here
  say text
