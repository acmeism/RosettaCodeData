class Program {
    static void Main(string[] args) { int bi, i = 0; string chars = args.Length < 1 ? "abc" : args[0];
        foreach (var item in System.IO.File.ReadAllLines("unixdict.txt")) {
            int ai = -1; foreach (var ch in chars)
                if ((bi = item.IndexOf(ch)) > ai) ai = bi; else goto skip;
            System.Console.Write("{0,3} {1,-18} {2}", ++i, item, i % 5 == 0 ? "\n" : "");
        skip: ; } }
}
