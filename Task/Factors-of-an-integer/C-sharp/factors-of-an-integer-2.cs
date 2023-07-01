using System;
using System.Collections.Generic;
using System.Linq;

public static class Extension {
    public static List<int> Factors (this int me) {
        return Enumerable.Range (1, me).Where (x => me % x == 0).ToList ();
    }
}

class Program {
    static void Main (string[] args) {
        Console.WriteLine (String.Join (", ", 45. Factors ()));
    }
}
