open System

let flip f x y = f y x

let rec cycle s = seq { yield! s; yield! cycle s }

type Agent<'T> = MailboxProcessor<'T>

type Message = Waiting of (Set<int> * AsyncReplyChannel<unit>) | Done of Set<int>

let reply (c: AsyncReplyChannel<_>) = c.Reply()

let strategy forks waiting =
    let aux, waiting = List.partition (fst >> flip Set.isSubset forks) waiting
    let forks = aux |> List.map fst |> List.fold (-) forks
    List.iter (snd >> reply) aux
    forks, waiting

let waiter strategy forkCount =
  Agent<_>.Start(fun inbox ->
    let rec loop forks waiting =
      async { let forks, waiting = strategy forks waiting
              let! msg = inbox.Receive()
              match msg with
                | Waiting r -> return! loop forks (waiting @ [r])
                | Done f -> return! loop (forks + f) waiting }
    loop (Set.ofList (List.init forkCount id)) [])

let philosopher (waiter: Agent<_>) name forks =
  let rng = new Random()
  let forks = Set.ofArray forks
  Agent<_>.Start(fun inbox ->
    let rec loop () =
      async { printfn "%s is thinking" name
              do! Async.Sleep(rng.Next(100, 500))
              printfn "%s is hungry" name
              do! waiter.PostAndAsyncReply(fun c -> Waiting (forks, c))
              printfn "%s is eating" name
              do! Async.Sleep(rng.Next(100, 500))
              printfn "%s is done eating" name
              waiter.Post(Done (forks))
              return! loop () }
    loop ())

[<EntryPoint>]
let main args =
  let forks = Seq.init 5 id |> cycle |> Seq.windowed 2 |> Seq.take 5 |> Seq.toList
  let names = ["plato"; "aristotel"; "kant"; "nietzsche"; "russel"]
  let waiter = waiter strategy 5
  List.map2 (philosopher waiter) names forks |> ignore
  Console.ReadLine() |> ignore
  0
