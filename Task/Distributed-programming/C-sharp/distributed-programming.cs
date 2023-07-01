using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Runtime.Serialization.Formatters.Binary;
using System.Threading.Tasks;

using static System.Console;

class DistributedProgramming
{
    const int Port = 555;

    async static Task RunClient()
    {
        WriteLine("Connecting");
        var client = new TcpClient();
        await client.ConnectAsync("localhost", Port);

        using (var stream = client.GetStream())
        {
            WriteLine("Sending loot");
            var data = Serialize(new SampleData());
            await stream.WriteAsync(data, 0, data.Length);

            WriteLine("Receiving thanks");
            var buffer = new byte[80000];
            var bytesRead = await stream.ReadAsync(buffer, 0, buffer.Length);
            var thanks = (string)Deserialize(buffer, bytesRead);
            WriteLine(thanks);
        }

        client.Close();
    }

    async static Task RunServer()
    {
        WriteLine("Listening");
        var listener = new TcpListener(IPAddress.Any, Port);
        listener.Start();
        var client = await listener.AcceptTcpClientAsync();

        using (var stream = client.GetStream())
        {
            WriteLine("Receiving loot");
            var buffer = new byte[80000];
            var bytesRead = await stream.ReadAsync(buffer, 0, buffer.Length);
            var data = (SampleData)Deserialize(buffer, bytesRead);
            WriteLine($"{data.Loot} at {data.Latitude}, {data.Longitude}");

            WriteLine("Sending thanks");
            var thanks = Serialize("Thanks!");
            await stream.WriteAsync(thanks, 0, thanks.Length);
        }

        client.Close();
        listener.Stop();
        Write("Press a key");
        ReadKey();
    }

    static byte[] Serialize(object data)
    {
        using (var mem = new MemoryStream())
        {
            new BinaryFormatter().Serialize(mem, data);
            return mem.ToArray();
        }
    }

    static object Deserialize(byte[] data, int length)
    {
        using (var mem = new MemoryStream(data, 0, length))
        {
            return new BinaryFormatter().Deserialize(mem);
        }
    }

    static void Main(string[] args)
    {
        if (args.Length == 0) return;

        switch (args[0])
        {
            case "client": RunClient().Wait(); break;
            case "server": RunServer().Wait(); break;
        }
    }
}

[Serializable]
class SampleData
{
    public decimal Latitude = 44.33190m;
    public decimal Longitude = 114.84129m;
    public string Loot = "140 tonnes of jade";
}
