using System;
public class Program
{
    public static void Main() {
        for (int p = 2; p <= 7; p+=2) {
            for (int s = 1; s <= 7; s++) {
                int f = 12 - p - s;
                if (s >= f) break;
                if (f > 7) continue;
                if (s == p || f == p) continue; //not even necessary
                Console.WriteLine($"Police:{p}, Sanitation:{s}, Fire:{f}");
                Console.WriteLine($"Police:{p}, Sanitation:{f}, Fire:{s}");
            }
        }
    }
}
