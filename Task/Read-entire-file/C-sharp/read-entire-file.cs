using System.IO;

class Program
{
    static void Main(string[] args)
    {
        var fileContents = File.ReadAllText("c:\\autoexec.bat");
        // Can optionally take a second parameter to specify the encoding, e.g. File.ReadAllText("c:\\autoexec.bat", Encoding.UTF8)
    }
}
