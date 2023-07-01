import grayscale_image, turtle;

void drawDragon(Color)(Image!Color img, ref Turtle t, in uint depth,
                       in real dir, in uint step) {
    if (depth == 0)
        return t.forward(img, step);
    t.right(dir);
    img.drawDragon(t, depth - 1, 45.0, step);
    t.left(dir * 2);
    img.drawDragon(t, depth - 1, -45.0, step);
    t.right(dir);
}

void main() {
    auto img = new Image!Gray(500, 700);
    auto t = Turtle(180, 510, -90);
    img.drawDragon(t, 14, 45.0, 3);
    img.savePGM("dragon_curve.pgm");
}
