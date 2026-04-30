fn circle(px int, py int, c int, r int) bool {
	mut x, mut y := px, py
    x = x / 2
    y = y - c
    return r * r >= x * x + y * y
}

fn pixel(x int, y int, r int) string {
    if circle(x, y, -r / 2, r / 6) { return "#" }
    if circle(x, y, r / 2, r / 6) { return "." }
    if circle(x, y, -r / 2, r / 2) { return "." }
    if circle(x, y, r / 2, r / 2) { return "#" }
    if circle(x, y, 0, r) {
        if x < 0 { return "." }
		else { return "#" }
    }
    return " "
}

fn yin_yang(r int) {
    for y := -r; y <= r; y++ {
        for x := -2 * r; x <= 2 * r; x++ {
            print(pixel(x, y, r))
        }
        println("")
    }
}

fn main() {
    yin_yang(18)
}
