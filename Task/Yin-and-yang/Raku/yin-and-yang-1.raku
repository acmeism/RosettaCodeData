sub circle ($rad, $cx, $cy, $fill = 'white', $stroke = 'black' ){
    say "<circle cx='$cx' cy='$cy' r='$rad' fill='$fill' stroke='$stroke' stroke-width='1'/>";
}

sub yin_yang ($rad, $cx, $cy, :$fill = 'white', :$stroke = 'black', :$angle = 90) {
    my ($c, $w) = (1, 0);
    say "<g transform='rotate($angle, $cx, $cy)'>" if $angle;
    circle($rad, $cx, $cy, $fill, $stroke);
    say "<path d='M $cx {$cy + $rad}A {$rad/2} {$rad/2} 0 0 $c $cx $cy ",
        "{$rad/2} {$rad/2} 0 0 $w $cx {$cy - $rad} $rad $rad 0 0 $c $cx ",
        "{$cy + $rad} z' fill='$stroke' stroke='none' />";
    circle($rad/5, $cx, $cy + $rad/2, $fill, $stroke);
    circle($rad/5, $cx, $cy - $rad/2, $stroke, $fill);
    say "</g>" if $angle;
}

say '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg height="400" width="400" xmlns="http://www.w3.org/2000/svg" version="1.1"
 xmlns:xlink="http://www.w3.org/1999/xlink">';

yin_yang(100, 130, 130);
yin_yang(50, 300, 300);

say '</svg>';
