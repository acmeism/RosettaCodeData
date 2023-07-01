open System

let rec loop n = Console.WriteLine( n:int )
                 Threading.Thread.Sleep( 500 )
                 loop (n + 1)

let main() =
   let start = DateTime.Now
   Console.CancelKeyPress.Add(
      fun _ -> let span = DateTime.Now - start
               printfn "Program has run for %.0f seconds" span.TotalSeconds
             )
   loop 1

main()
