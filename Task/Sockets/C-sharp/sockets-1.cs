using System;
using System.IO;
using System.Net.Sockets;

class Program {
    static void Main(string[] args) {
        TcpClient tcp = new TcpClient("localhost", 256);
        StreamWriter writer = new StreamWriter(tcp.GetStream());

        writer.Write("hello socket world");
        writer.Flush();

        tcp.Close();
    }
}
