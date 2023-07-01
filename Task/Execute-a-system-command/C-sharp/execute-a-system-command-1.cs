using System.Diagnostics;

namespace Execute
{
    class Program
    {
        static void Main(string[] args)
        {
            Process.Start("cmd.exe", "/c dir");
        }
    }
}
