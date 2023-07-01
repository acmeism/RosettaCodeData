open System.Diagnostics
let myfunc data =
    let timer = new Stopwatch()
    timer.Start()
    let result = data |> expensive_processing
    timer.Stop()
    printf "elapsed %d ms" timer.ElapsedMilliseconds
    result
