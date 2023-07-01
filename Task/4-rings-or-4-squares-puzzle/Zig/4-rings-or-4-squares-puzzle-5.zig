fn validComb(a: usize, b: usize, c: usize, d: usize, e: usize, f: usize, g: usize) bool {
    const square1 = a + b;
    const square2 = b + c + d;
    const square3 = d + e + f;
    const square4 = f + g;
    return square1 == square2 and square2 == square3 and square3 == square4;
}
