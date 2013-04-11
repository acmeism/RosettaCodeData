class Circle {
   has $.x;
   has $.y;
   has $.r;
   method gist { "circle($!x, $!y, $!r)" }
}

sub circle($x,$y,$r) { Circle.new: :$x, :$y, :$r }

sub postfix:<²>($x) { $x * $x }

sub solve-Apollonius([\c1, \c2, \c3], [\s1, \s2, \s3]) {
    my \𝑣11 = 2 * c2.x - 2 * c1.x;
    my \𝑣12 = 2 * c2.y - 2 * c1.y;
    my \𝑣13 = c1.x² - c2.x² + c1.y² - c2.y² - c1.r² + c2.r²;
    my \𝑣14 = 2 * s2 * c2.r - 2 * s1 * c1.r;

    my \𝑣21 = 2 * c3.x - 2 * c2.x;
    my \𝑣22 = 2 * c3.y - 2 * c2.y;
    my \𝑣23 = c2.x² - c3.x² + c2.y² - c3.y² - c2.r² + c3.r²;
    my \𝑣24 = 2 * s3 * c3.r - 2 * s2 * c2.r;

    my \𝑤12 = 𝑣12 / 𝑣11;
    my \𝑤13 = 𝑣13 / 𝑣11;
    my \𝑤14 = 𝑣14 / 𝑣11;

    my \𝑤22 = 𝑣22 / 𝑣21 - 𝑤12;
    my \𝑤23 = 𝑣23 / 𝑣21 - 𝑤13;
    my \𝑤24 = 𝑣24 / 𝑣21 - 𝑤14;

    my \𝑃 = -𝑤23 / 𝑤22;
    my \𝑄 = 𝑤24 / 𝑤22;
    my \𝑀 = -𝑤12 * 𝑃 - 𝑤13;
    my \𝑁 = 𝑤14 - 𝑤12 * 𝑄;

    my \𝑎 = 𝑁² + 𝑄² - 1;
    my \𝑏 = 2 * 𝑀 * 𝑁 - 2 * 𝑁 * c1.x + 2 * 𝑃 * 𝑄 - 2 * 𝑄 * c1.y + 2 * s1 * c1.r;
    my \𝑐 = c1.x² + 𝑀² - 2 * 𝑀 * c1.x + 𝑃² + c1.y² - 2 * 𝑃 * c1.y - c1.r²;

    my \𝐷 = 𝑏² - 4 * 𝑎 * 𝑐;
    my \rs = (-𝑏 - sqrt 𝐷) / (2 * 𝑎);

    my \xs = 𝑀 + 𝑁 * rs;
    my \ys = 𝑃 + 𝑄 * rs;

    circle(xs, ys, rs);
}

sub MAIN {
    my @c = circle(0, 0, 1), circle(4, 0, 1), circle(2, 4, 2);
    say solve-Apollonius @c, <1 1 1>;
    say solve-Apollonius @c, <-1 -1 -1>;
}
