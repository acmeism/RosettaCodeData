string str = "Hello,How,Are,You,Today";
// or Regex.Split ( "Hello,How,Are,You,Today", "," );
// (Regex is in System.Text.RegularExpressions namespace)
string[] strings = str.Split(',');
Console.WriteLine(String.Join(".", strings));
