sub printVerse {
    $x  = ucfirst lc shift;
    $x0 = substr $x, 0, 1;
    $y  = $x0 =~ /[AEIOU]/ ? lc $x : substr $x, 1;
    $b  = $x0 eq 'B' ? $y : 'b' . $y;
    $f  = $x0 eq 'F' ? $y : 'f' . $y;
    $m  = $x0 eq 'M' ? $y : 'm' . $y;
    print "$x, $x, bo-$b\n" .
          "Banana-fana fo-$f\n" .
          "Fee-fi-mo-$m\n" .
          "$x!\n\n";
}

printVerse($_) for <Gary Earl Billy Felix Mary Steve>;
