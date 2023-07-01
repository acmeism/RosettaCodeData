Console.WriteLine((new[] { 1, 2, 3, 4 }).Zip(new[] { "a", "b", "c" },
(f, s) => f + " " + s));
