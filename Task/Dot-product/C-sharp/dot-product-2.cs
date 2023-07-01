public static decimal DotProduct(decimal[] a, decimal[] b) {
    return a.Zip(b, (x, y) => x * y).Sum();
}
