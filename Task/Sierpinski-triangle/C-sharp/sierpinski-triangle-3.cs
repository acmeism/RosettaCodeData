using static System.Console;
class Sierpinsky
{
    static void Main(string[] args)
    {
        int order;
        if(!int.TryParse(args.Length > 0 ? args[0] : "", out order)) order = 4;
        int size = (1 << order);
        for (int y = size - 1; y >= 0; y--, WriteLine())
        {
            for (int i = 0; i < y; i++) Write(' ');
            for (int x = 0; x + y < size; x++)
                Write((x & y) != 0 ? "  " : "* ");
        }
    }
}
