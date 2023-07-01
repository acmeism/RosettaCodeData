using System.Runtime.InteropServices;

class Program {
    [DllImport("fakelib.dll")]
    public static extern int fakefunction(int args);

    static void Main(string[] args) {
        int r = fakefunction(10);
    }
}
