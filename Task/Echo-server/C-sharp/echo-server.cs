using System.Net.Sockets;
using System.Threading;

namespace ConsoleApplication1
{
    class Program
    {
        static TcpListener listen;
        static Thread serverthread;

        static void Main(string[] args)
        {
            listen = new TcpListener(System.Net.IPAddress.Parse("127.0.0.1"), 12321);
            serverthread = new Thread(new ThreadStart(DoListen));
            serverthread.Start();
        }

        private static void DoListen()
        {
            // Listen
            listen.Start();
            Console.WriteLine("Server: Started server");

            while (true)
            {
                Console.WriteLine("Server: Waiting...");
                TcpClient client = listen.AcceptTcpClient();
                Console.WriteLine("Server: Waited");

                // New thread with client
                Thread clientThread = new Thread(new ParameterizedThreadStart(DoClient));
                clientThread.Start(client);
            }
        }

        private static void DoClient(object client)
        {
            // Read data
            TcpClient tClient = (TcpClient)client;

            Console.WriteLine("Client (Thread: {0}): Connected!", Thread.CurrentThread.ManagedThreadId);
            do
            {
                if (!tClient.Connected)
                {
                    tClient.Close();
                    Thread.CurrentThread.Abort();       // Kill thread.
                }

                if (tClient.Available > 0)
                {
                    // Resend
                    byte pByte = (byte)tClient.GetStream().ReadByte();
                    Console.WriteLine("Client (Thread: {0}): Data {1}", Thread.CurrentThread.ManagedThreadId, pByte);
                    tClient.GetStream().WriteByte(pByte);
                }

                // Pause
                Thread.Sleep(100);
            } while (true);
        }
    }
}
