my $l = '';  # Sample longest string seen.
my $a = '';  # Accumulator to save longest strings.

while $*IN.get -> $s {
   my $n = "$s\n";
   if $n.substr($l.chars) {     # Is new string longer?
       $a = $l = $n;            # Reset accumulator.
   }
   elsif !$l.substr($n.chars) { # Same length?
      $a ~= $n;                 # Accumulate it.
   }
}
print $a;
