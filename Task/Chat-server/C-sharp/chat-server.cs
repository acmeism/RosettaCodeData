using System;
using System.Collections.Generic;
using System.Net.Sockets;
using System.Text;
using System.Threading;

namespace ChatServer {
    class State {
        private TcpClient client;
        private StringBuilder sb = new StringBuilder();

        public string Name { get; }

        public State(string name, TcpClient client) {
            Name = name;
            this.client = client;
        }

        public void Add(byte b) {
            sb.Append((char)b);
        }

        public void Send(string text) {
            var bytes = Encoding.ASCII.GetBytes(string.Format("{0}\r\n", text));
            client.GetStream().Write(bytes, 0, bytes.Length);
        }
    }

    class Program {
        static TcpListener listen;
        static Thread serverthread;
        static Dictionary<int, State> connections = new Dictionary<int, State>();

        static void Main(string[] args) {
            listen = new TcpListener(System.Net.IPAddress.Parse("127.0.0.1"), 4004);
            serverthread = new Thread(new ThreadStart(DoListen));
            serverthread.Start();
        }

        private static void DoListen() {
            // Listen
            listen.Start();
            Console.WriteLine("Server: Started server");

            while (true) {
                Console.WriteLine("Server: Waiting...");
                TcpClient client = listen.AcceptTcpClient();
                Console.WriteLine("Server: Waited");

                // New thread with client
                Thread clientThread = new Thread(new ParameterizedThreadStart(DoClient));
                clientThread.Start(client);
            }
        }

        private static void DoClient(object client) {
            // Read data
            TcpClient tClient = (TcpClient)client;

            Console.WriteLine("Client (Thread: {0}): Connected!", Thread.CurrentThread.ManagedThreadId);
            byte[] bytes = Encoding.ASCII.GetBytes("Enter name: ");
            tClient.GetStream().Write(bytes, 0, bytes.Length);

            string name = string.Empty;
            bool done = false;
            do {
                if (!tClient.Connected) {
                    Console.WriteLine("Client (Thread: {0}): Terminated!", Thread.CurrentThread.ManagedThreadId);
                    tClient.Close();
                    Thread.CurrentThread.Abort();       // Kill thread.
                }

                name = Receive(tClient);
                done = true;

                if (done) {
                    foreach (var cl in connections) {
                        var state = cl.Value;
                        if (state.Name == name) {
                            bytes = Encoding.ASCII.GetBytes("Name already registered. Please enter your name: ");
                            tClient.GetStream().Write(bytes, 0, bytes.Length);
                            done = false;
                        }
                    }
                }
            } while (!done);

            connections.Add(Thread.CurrentThread.ManagedThreadId, new State(name, tClient));
            Console.WriteLine("\tTotal connections: {0}", connections.Count);
            Broadcast(string.Format("+++ {0} arrived +++", name));

            do {
                string text = Receive(tClient);
                if (text == "/quit") {
                    Broadcast(string.Format("Connection from {0} closed.", name));
                    connections.Remove(Thread.CurrentThread.ManagedThreadId);
                    Console.WriteLine("\tTotal connections: {0}", connections.Count);
                    break;
                }

                if (!tClient.Connected) {
                    break;
                }
                Broadcast(string.Format("{0}> {1}", name, text));
            } while (true);

            Console.WriteLine("Client (Thread: {0}): Terminated!", Thread.CurrentThread.ManagedThreadId);
            tClient.Close();
            Thread.CurrentThread.Abort();
        }

        private static string Receive(TcpClient client) {
            StringBuilder sb = new StringBuilder();
            do {
                if (client.Available > 0) {
                    while (client.Available > 0) {
                        char ch = (char)client.GetStream().ReadByte();
                        if (ch == '\r') {
                            //ignore
                            continue;
                        }
                        if (ch == '\n') {
                            return sb.ToString();
                        }
                        sb.Append(ch);
                    }
                }

                // Pause
                Thread.Sleep(100);
            } while (true);
        }

        private static void Broadcast(string text) {
            Console.WriteLine(text);
            foreach (var oClient in connections) {
                if (oClient.Key != Thread.CurrentThread.ManagedThreadId) {
                    State state = oClient.Value;
                    state.Send(text);
                }
            }
        }
    }
}
