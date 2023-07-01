using System;
using System.Net;
using System.Net.Sockets;

class Program {
    static void Main(string[] args) {
        try {
            TcpListener server = new TcpListener(IPAddress.Any, 12345);
            server.Start();
        }

        catch (SocketException e) {
            if (e.SocketErrorCode == SocketError.AddressAlreadyInUse) {
                Console.Error.WriteLine("Already running.");
            }
        }
    }
}
