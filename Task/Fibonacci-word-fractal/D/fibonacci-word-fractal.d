import std.range, grayscale_image, turtle;

void drawFibonacci(Color)(Image!Color img, ref Turtle t,
                          in string word, in real step) {
    foreach (immutable i, immutable c; word) {
        t.forward(img, step);
        if (c == '0') {
            if ((i + 1) % 2 == 0)
                t.left(90);
            else
                t.right(90);
        }
    }
}

void main() {
    auto img = new Image!Gray(1050, 1050);
    auto t = Turtle(30, 1010, -90);
    const w = recurrence!q{a[n-1] ~ a[n-2]}("1", "0").drop(24).front;
    img.drawFibonacci(t, w, 1);
    img.savePGM("fibonacci_word_fractal.pgm");
}
