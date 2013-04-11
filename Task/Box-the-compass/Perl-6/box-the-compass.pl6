sub point (Int $index) {
    my $ix = $index % 32;
    if $ix +& 1
        { "&point(($ix + 1) +& 28) by &point(((2 - ($ix +& 2)) * 4) + $ix +& 24)" }
    elsif $ix +& 2
        { "&point(($ix + 2) +& 24)-&point(($ix +| 4) +& 28)" }
    elsif $ix +& 4
        { "&point(($ix + 8) +& 16)&point(($ix +| 8) +& 24)" }
    else
        { <north east south west>[$ix div 8]; }
}

sub test-angle ($ix) { $ix * 11.25 + (0, 5.62, -5.62)[ $ix % 3 ] }
sub angle-to-point($𝜽) { floor $𝜽 / 360 * 32 + 0.5 }

for 0 .. 32 -> $ix {
    my $𝜽 = test-angle($ix);
    printf "  %2d %6.2f%s %s\n",
              $ix % 32 + 1,
                  $𝜽, '°',
                          ucfirst point angle-to-point $𝜽;
}
