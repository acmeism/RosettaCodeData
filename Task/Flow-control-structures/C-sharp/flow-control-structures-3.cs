public static void Main() {
    foreach (int n in Numbers(i => i >= 2) {
        Console.WriteLine("Got " + n);
    }
}

IEnumerable<int> Numbers(Func<int, bool> predicate) {
    for (int i = 0; ; i++) {
        if (predicate(i)) yield break;
        Console.WriteLine("Yielding " + i);
        yield return i;
    }
}
