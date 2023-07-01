using System;
using System.IO;
using System.Text;

namespace RosettaCode
{
  internal class Program
  {
    private const string FileName = "NOTES.TXT";

    private static void Main(string[] args)
    {
      if (args.Length==0)
      {
        string txt = File.ReadAllText(FileName);
        Console.WriteLine(txt);
      }
      else
      {
        var sb = new StringBuilder();
        sb.Append(DateTime.Now).Append("\n\t");
        foreach (string s in args)
          sb.Append(s).Append(" ");
        sb.Append("\n");

        if (File.Exists(FileName))
          File.AppendAllText(FileName, sb.ToString());
        else
          File.WriteAllText(FileName, sb.ToString());
      }
    }
  }
}
