use ntheory qw/forprimes is_prime vecprod/;

forprimes { my $p = $_;
   for my $h3 (2 .. $p-1) {
      my $ph3 = $p + $h3;
      for my $d (1 .. $ph3-1) {               # Jameseon procedure page 6
         next if ((-$p*$p) % $h3) != ($d % $h3);
         next if (($p-1)*$ph3) % $d;
         my $q = 1 + ($p-1)*$ph3 / $d;        # Jameson eq 7
         next unless is_prime($q);
         my $r = 1 + ($p*$q-1) / $h3;         # Jameson eq 6
         next unless is_prime($r);
         next unless ($q*$r) % ($p-1) == 1;
         printf "%2d x %5d x %5d = %s\n",$p,$q,$r,vecprod($p,$q,$r);
      }
   }
} 3,61;
