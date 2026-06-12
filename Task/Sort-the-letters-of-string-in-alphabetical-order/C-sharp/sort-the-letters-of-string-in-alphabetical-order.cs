using System; using static System.Console;
class Program {
  static void Main(string[] args) {
    var nl = "\n";
    var omit_spaces = true;
    var str = "forever ring programming language";
    Write( "working..." + nl );
    Write( "Sort the letters of string in alphabitical order:" + nl );
    Write( "Input: " + str + nl );
    Write( "Output: " );
    for (var ch = omit_spaces ? 33 : 0; ch < 256; ch++)
      foreach (var itm in str)
        if (ch == itm) Console.Write(itm);
    Write( nl + "done..." );
  }
}
