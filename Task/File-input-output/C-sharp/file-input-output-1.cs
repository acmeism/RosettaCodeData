using System.IO;

using (var reader = new StreamReader("input.txt"))
using (var writer = new StreamWriter("output.txt"))
{
    var text = reader.ReadToEnd();
    writer.Write(text);
}
