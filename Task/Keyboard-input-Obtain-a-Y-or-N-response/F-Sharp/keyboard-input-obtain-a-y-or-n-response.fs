open System

let rec yorn () =
    let rec flush () = if Console.KeyAvailable then ignore (Console.ReadKey()); flush ()
    flush ()

    printf "\nY or N? "
    match Console.ReadKey().Key with
    | ConsoleKey.Y -> 'Y'
    | ConsoleKey.N -> 'N'
    | _ -> yorn()

printfn "\nYour choice: %c" (yorn())
