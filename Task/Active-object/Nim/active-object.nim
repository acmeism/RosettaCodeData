# Active object.
# Compile with "nim c --threads:on".

import locks
import os
import std/monotimes

type

  # Function to use for integration.
  TimeFunction = proc (t: float): float {.gcsafe.}

  # Integrator object.
  Integrator = ptr TIntegrator
  TIntegrator = object
    k: TimeFunction                 # The function to integrate.
    dt: int                         # Time interval in milliseconds.
    thread: Thread[Integrator]      # Thread which does the computation.
    s: float                        # Computed value.
    lock: Lock                      # Lock to manage concurrent accesses.
    isRunning: bool                 # True if integrator is running.

#---------------------------------------------------------------------------------------------------

proc newIntegrator(f: TimeFunction; dt: int): Integrator =
  ## Create an integrator.

  result = cast[Integrator](allocShared(sizeof(TIntegrator)))
  result.k = f
  result.dt = dt
  result.s = 0
  result.lock.initLock()
  result.isRunning = false

#---------------------------------------------------------------------------------------------------

proc process(integrator: Integrator) {.thread, gcsafe.} =
  ## Do the integration.

  integrator.isRunning = true
  let start = getMonotime().ticks
  var t0: float = 0
  var k0 = integrator.k(0)
  while true:
    sleep(integrator.dt)
    withLock integrator.lock:
      if not integrator.isRunning:
        break
      let t1 = float(getMonoTime().ticks - start) / 1e9
      let k1 = integrator.k(t1)
      integrator.s += (k1 + k0) * (t1 - t0) / 2
      t0 = t1
      k0 = k1

#---------------------------------------------------------------------------------------------------

proc start(integrator: Integrator) =
  ## Start the integrator by launching a thread to do the computation.
  integrator.thread.createThread(process, integrator)

#---------------------------------------------------------------------------------------------------

proc stop(integrator: Integrator) =
  ## Stop the integrator.

  withLock integrator.lock:
    integrator.isRunning = false
  integrator.thread.joinThread()

#---------------------------------------------------------------------------------------------------

proc setInput(integrator: Integrator; f: TimeFunction) =
  ## Set the function.
  withLock integrator.lock:
    integrator.k = f

#---------------------------------------------------------------------------------------------------

proc output(integrator: Integrator): float =
  ## Return the current output.
  withLock integrator.lock:
    result = integrator.s

#---------------------------------------------------------------------------------------------------

proc destroy(integrator: Integrator) =
  ## Destroy an integrator, freing the resources.

  if integrator.isRunning:
    integrator.stop()
  integrator.lock.deinitLock()
  integrator.deallocShared()

#---------------------------------------------------------------------------------------------------

from math import PI, sin

# Create the integrator and start it.
let integrator = newIntegrator(proc (t: float): float {.gcsafe.} = sin(PI * t), 1)
integrator.start()
echo "Integrator started."
sleep(2000)
echo "Value after 2 seconds: ", integrator.output()

# Change the function to use.
integrator.setInput(proc (t: float): float {.gcsafe.} = 0)
echo "K function changed."
sleep(500)

# Stop the integrator and display the computed value.
integrator.stop()
echo "Value after 0.5 more second: ", integrator.output()
integrator.destroy()
