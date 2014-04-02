sub halve  { $^n div 2 }
sub double { $^n * 2   }
sub even   { $^n %% 2  }

sub ethiopic-mult ($a, $b) {
    [+] ($b, &double ... *)
        Z*
        ($a, &halve ... 0).map: { not even $^n }
}

say ethiopic-mult(17,34);
