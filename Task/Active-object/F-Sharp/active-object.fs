open System
open System.Threading

// current time in seconds
let now() = float( DateTime.Now.Ticks / 10000L ) / 1000.0

type Integrator( intervalMs ) as x =
  let mutable k = fun _ -> 0.0  // function to integrate
  let mutable s = 0.0           // current value
  let mutable t0 = now()        // last time s was updated
  let mutable running = true    // still running?

  do x.ScheduleNextUpdate()

  member x.Input(f) = k <- f

  member x.Output() = s

  member x.Stop() = running <- false

  member private x.Update() =
    let t1 = now()
    s <- s + (k t0 + k t1) * (t1 - t0) / 2.0
    t0 <- t1
    x.ScheduleNextUpdate()

  member private x.ScheduleNextUpdate() =
    if running then
      async { do! Async.Sleep( intervalMs )
              x.Update()
            }
      |> Async.Start

let i = new Integrator(10)

i.Input( fun t -> Math.Sin (2.0 * Math.PI * 0.5 * t) )
Thread.Sleep(2000)

i.Input( fun _ -> 0.0 )
Thread.Sleep(500)

printfn "%f" (i.Output())
i.Stop()
