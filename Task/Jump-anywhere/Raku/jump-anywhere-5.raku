  sub foo($i) {
      if $i == 0 {
          die "Are you sure you want /0?";
      }
      say "Dividing by $i";
      1/$i.Num + 0; # Fighting hard to make this fail
  }

  for ^10 -> $n {
      say "1/$n  = " ~ foo($n);
  }

  CATCH {
      when ~$_ ~~ m:s/Are you sure/ { .resume; #`(yes, I'm sure) }
  }
