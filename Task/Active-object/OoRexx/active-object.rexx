integrater = .integrater~new(.routines~sine)   -- start the integrater function
call syssleep 2
integrater~input = .routines~zero              -- update the integrater function
call syssleep .5

say integrater~output
integrater~stop          -- terminate the updater thread

::class integrater
::method init
  expose stopped start v last_v last_t k
  use strict arg k
  stopped = .false
  start = .datetime~new   -- initial time stamp
  v = 0
  last_v = 0
  last_t = 0
  self~input = k
  self~start

-- spin off a new thread and start updating.  Note, this method is unguarded
-- to allow other threads to make calls
::method start unguarded
  expose stopped

  reply  -- this spins this method invocation off onto a new thread

  do while \stopped
    call sysSleep .1
    self~update    -- perform the update operation
  end

-- turn off the thread.  Since this is unguarded,
-- it can be called any time, any where
::method stop unguarded
  expose stopped
  stopped = .true

-- perform the update.  Since this is a guarded method, the object
-- start is protected.
::method update
  expose start v last_v t last_t k

  numeric digits 20   -- give a lot of precision

  current = .datetime~new
  t = (current - start)~microseconds
  new_v = k~call(t)    -- call the input function
  v += (last_v + new_v) * (t - last_t) / 2
  last_t = t
  last_v = new_v
  say new value is v

-- a write-only attribute setter (this is GUARDED)
::attribute input SET
  expose k last_t last_v
  self~update          -- update current values
  use strict arg k  -- update the call function to the provided value
  last_t = 0
  last_v = k~call(0)  -- and update to the zero value

-- the output function...returns current calculated value
::attribute output GET
  expose v
  return v

::routine zero
  return 0

::routine sine
  use arg t
  return rxcalcsin(rxcalcpi() * t)

::requires rxmath library
