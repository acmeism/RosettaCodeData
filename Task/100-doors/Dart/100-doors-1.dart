main() {
    for (var k = 1, x = new List(101); k <= 100; k++) {
        for (int i = k; i <= 100; i += k)
            x[i] = !x[i];
        if (x[k]) print("$k open");
    }
}
