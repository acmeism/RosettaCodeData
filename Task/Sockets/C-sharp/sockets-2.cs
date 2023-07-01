using System.Text;
using System.Net.Sockets;

namespace SocketClient
{
    class Program
    {
        static void Main(string[] args)
        {
            var sock = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            sock.Connect("127.0.0.1", 1000);
            sock.Send(Encoding.ASCII.GetBytes("Hell, world!"));
            sock.Close();
        }
    }
}
