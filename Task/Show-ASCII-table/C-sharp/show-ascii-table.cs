using static System.Console;
using static System.Linq.Enumerable;

public class Program
{
    static void Main()
    {
        for (int start = 32; start + 16 * 5 < 128; start++) {
            WriteLine(string.Concat(Range(0, 6).Select(i => $"{start+16*i, 3} : {Text(start+16*i), -6}")));
        }

        string Text(int index) => index == 32 ? "Sp" : index == 127 ? "Del" : (char)index + "";
    }
}
