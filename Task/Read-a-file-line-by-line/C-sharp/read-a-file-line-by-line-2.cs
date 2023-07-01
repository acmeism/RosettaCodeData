using System;
using System.IO;
using System.Text;

namespace RosettaCode
{
  internal class Program
  {
    private static void Main()
    {
      var sb = new StringBuilder();
      string F = "File.txt";

      // Read a file, line by line.
      try
      {
        foreach (string readLine in File.ReadLines(F))
        {
          // Use the data in some way...
          sb.Append(readLine);
          sb.Append("\n");
        }
      }
      catch (Exception exception)
      {
        Console.WriteLine(exception.Message);
        Environment.Exit(1);
      }

      // Preset the results
      Console.WriteLine(sb.ToString());
    }
  }
}
