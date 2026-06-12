private static readonly Random Rand = new Random();

void sattoloCycle<T>(IList<T> items) {
    for (var i = items.Count; i-- > 1;) {
        int j = Rand.Next(i);
        var tmp = items[i];
        items[i] = items[j];
        items[j] = tmp;
    }
}
