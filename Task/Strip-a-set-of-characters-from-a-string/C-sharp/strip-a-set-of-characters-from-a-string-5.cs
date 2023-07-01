using System;

class Program
{
  static void Main(string[] args)
  {
    var stripString = "She was a soul stripper. She took my heart!";
    var removeString = "aei";
    System.Console.WriteLine(RemoveItems<char>(stripString.ToCharArray(), removeString).ToString());
  }
}
