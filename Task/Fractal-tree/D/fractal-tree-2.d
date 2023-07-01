import grayscale_image, turtle;

void tree(Color)(Image!Color img, ref Turtle t, in uint depth,
                 in real step, in real scale, in real angle) {
    if (depth == 0) return;
    t.forward(img, step);
    t.right(angle);
    img.tree(t, depth - 1, step * scale, scale, angle);
    t.left(2 * angle);
    img.tree(t, depth - 1, step * scale, scale, angle);
    t.right(angle);
    t.forward(img, -step);
}

void main() {
    auto img = new Image!Gray(330, 300);
    auto t = Turtle(165, 270, -90);
    img.tree(t, 10, 80, 0.7, 30);
    img.savePGM("fractal_tree.pgm");
}
