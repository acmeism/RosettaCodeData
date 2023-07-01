using System.Text;
using System.Net.Sockets;
using System.Net;

namespace WebServer
{
    class GoodByeWorld
    {
        static void Main(string[] args)
        {
            const string msg = "<html>\n<body>\nGoodbye, world!\n</body>\n</html>\n";
            const int port = 8080;
            bool serverRunning = true;

            TcpListener tcpListener = new TcpListener(IPAddress.Any, port);
            tcpListener.Start();

            while (serverRunning)
            {
                Socket socketConnection = tcpListener.AcceptSocket();
                byte[] bMsg = Encoding.ASCII.GetBytes(msg.ToCharArray(), 0, (int)msg.Length);
                socketConnection.Send(bMsg);
                socketConnection.Disconnect(true);
            }
        }
    }
}
