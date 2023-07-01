open System
open System.Timers

let onElapsed (sender : obj) (eventArgs : ElapsedEventArgs) =
    printfn "%A" eventArgs.SignalTime
    (sender :?> Timer).Stop()

[<EntryPoint>]
let main argv =
    let timer = new Timer(1000.)
    timer.Elapsed.AddHandler(new ElapsedEventHandler(onElapsed))
    printfn "%A" DateTime.Now
    timer.Start()
    ignore <| Console.ReadLine()
    0
