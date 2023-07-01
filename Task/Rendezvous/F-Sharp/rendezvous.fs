open System

type PrinterCommand = Print of string

// a message is a command and a facility to return an exception
type Message = Message of PrinterCommand * AsyncReplyChannel<Exception option>

// thrown if we have no more ink (and neither has our possible backup printer)
exception OutOfInk

type Printer(id, ?backup:Printer) =
   let mutable ink = 5

   // the actual printing logic as a private function
   let print line =
      if ink > 0 then
         printf "%d: " id
         Seq.iter (printf "%c") line
         printf "\n"
         ink <- ink - 1
      else
         match backup with
         | Some p -> p.Print line
         | None -> raise OutOfInk

   // use a MailboxProcessor to process commands asynchronously;
   // if an exception occurs, we return it to the calling thread
   let agent = MailboxProcessor.Start( fun inbox ->
      async {
         while true do
            let! Message (command, replyChannel) = inbox.Receive()
            try
               match command with
               | Print line -> print line
               replyChannel.Reply None
            with
               | ex -> replyChannel.Reply (Some ex)
      })

   // public printing method:
   // send Print command and propagate exception if one occurs
   member x.Print line =
      match agent.PostAndReply( fun replyChannel -> Message (Print line, replyChannel) ) with
      | None -> ()
      | Some ex -> raise ex


open System.Threading

do
  let main = new Printer(id=1, backup=new Printer(id=2))

  (new Thread(fun () ->
      try
        main.Print "Humpty Dumpty sat on a wall."
        main.Print "Humpty Dumpty had a great fall."
        main.Print "All the king's horses and all the king's men"
        main.Print "Couldn't put Humpty together again."
      with
        | OutOfInk -> printfn "      Humpty Dumpty out of ink!"
  )).Start()

  (new Thread(fun () ->
      try
        main.Print "Old Mother Goose"
        main.Print "Would ride through the air"
        main.Print "On a very fine gander."
        main.Print "Jack's mother came in,"
        main.Print "And caught the goose soon,"
        main.Print "And mounting its back,"
        main.Print "Flew up to the moon."
      with
        | OutOfInk -> printfn "      Mother Goose out of ink!"
  )).Start()

  Console.ReadLine() |> ignore
