using System;

namespace TypeDetection {
    class C { }
    struct S { }
    enum E {
        NONE,
    }

    class Program {
        static void ShowType<T>(T t) {
            Console.WriteLine("The type of '{0}' is {1}", t, t.GetType());
        }

        static void Main() {
            ShowType(5);
            ShowType(7.5);
            ShowType('d');
            ShowType(true);
            ShowType("Rosetta");
            ShowType(new C());
            ShowType(new S());
            ShowType(E.NONE);
            ShowType(new int[] { 1, 2, 3 });
        }
    }
}
