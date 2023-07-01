open System
open System.Threading

[<EntryPoint>]
let main args =
    let sleep = Convert.ToInt32(Console.ReadLine())
    Console.WriteLine("Sleeping...")
    Thread.Sleep(sleep); //milliseconds
    Console.WriteLine("Awake!")
    0
