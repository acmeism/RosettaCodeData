int[] array = { 1, 2, 3, 4, 5 };
int[] evens = array.Where(i => (i % 2) == 0).ToArray();

foreach (int i in evens)
    Console.WriteLine(i);
