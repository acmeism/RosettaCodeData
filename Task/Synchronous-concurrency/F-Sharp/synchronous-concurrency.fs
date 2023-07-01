open System.IO

type Msg =
    | PrintLine of string
    | GetCount of AsyncReplyChannel<int>

let printer =
    MailboxProcessor.Start(fun inbox ->
        let rec loop count =
            async {
                let! msg = inbox.Receive()
                match msg with
                | PrintLine(s) ->
                    printfn "%s" s
                    return! loop (count + 1)
                | GetCount(reply) ->
                    reply.Reply(count)
                    return! loop count
            }
        loop 0
    )

let reader (printAgent:MailboxProcessor<Msg>) file =
    File.ReadLines(file)
    |> Seq.iter (fun line -> PrintLine line |> printAgent.Post)
    printAgent.PostAndReply(fun reply -> GetCount(reply))
    |> printfn "Lines written: %i"

reader printer @"c:\temp\input.txt"
