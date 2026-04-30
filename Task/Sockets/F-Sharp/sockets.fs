open System.Text
open System.Net.Sockets

let sock =
    new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp)
sock.Connect("127.0.0.1", 256)
sock.Send(Encoding.UTF8.GetBytes "hello socket world")
sock.Close
