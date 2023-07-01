module Seq =
    let piter f xs =
        seq { for x in xs -> async { f x } }
        |> Async.Parallel
        |> Async.RunSynchronously
        |> ignore

let main() =  Seq.piter
                (System.Console.WriteLine:string->unit)
                ["Enjoy"; "Rosetta"; "Code";]

main()
