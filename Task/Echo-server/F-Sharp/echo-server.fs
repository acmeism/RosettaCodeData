open System.IO
open System.Net
open System.Net.Sockets

let service (client:TcpClient) =
    use stream = client.GetStream()
    use out = new StreamWriter(stream, AutoFlush = true)
    use inp = new StreamReader(stream)
    while not inp.EndOfStream do
        match inp.ReadLine() with
        | line -> printfn "< %s" line
                  out.WriteLine(line)
    printfn "closed %A" client.Client.RemoteEndPoint
    client.Close |> ignore

let EchoService =
    let socket = new TcpListener(IPAddress.Loopback, 12321)
    do socket.Start()
    printfn "echo service listening on %A" socket.Server.LocalEndPoint
    while true do
        let client = socket.AcceptTcpClient()
        printfn "connect from %A" client.Client.RemoteEndPoint
        let job = async {
            use c = client in try service client with _ -> () }
        Async.Start job

[<EntryPoint>]
let main _ =
    EchoService
    0
