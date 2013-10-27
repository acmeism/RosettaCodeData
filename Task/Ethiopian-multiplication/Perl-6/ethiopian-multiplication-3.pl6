sub halve  { $^n div 2 }
sub double { $^n * 2   }
sub even   { $^n %% 2  }

sub ethiopicmult ($a, $b) {
    [+]
    map { $^column_2 if !even $^column_1 },
    zip($a, &halve ... 0;  $b, &double ... *);
}
