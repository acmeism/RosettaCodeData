# 20240211 Raku programming solution

sub nextword($n, $w, $alphabet) {
   my $x = ($w x ($n div $w.chars + 1)).substr(0, $n);
   while $x.Bool && $x.substr(*-1) eq $alphabet.substr(*-1) {
      $x.substr-rw(*-1) = ''
   }
   if $x.Bool {
      my $next_char_index  = ($alphabet.index($x.substr(*-1)) // 0) + 1;
      $x.substr-rw(*-1, 1) = $alphabet.substr($next_char_index, 1);
   }
   return $x;
}

.say for sub ($n, $alphabet) {
   my $w = $alphabet.substr(0, 1);
   return gather while $w.chars <= $n {
      take $w;
      last unless $w = nextword($n, $w, $alphabet);
   }
}(5, '01');
