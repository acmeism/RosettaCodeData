my @Fusc = 0, 1, 1, { |(@Fusc[$_ - 1] + @Fusc[$_], @Fusc[$_]) given ++$+1 } ... *;

sub comma { $^i.flip.comb(3).join(',').flip }

put "First 61 terms of the Fusc sequence:\n{@Fusc[^61]}" ~
    "\n\nIndex and value for first term longer than any previous:";

for flat 'Index', 'Value', 0, 0, (1..4).map({
    my $l = 10**$_;
    @Fusc.first(* > $l, :kv).map: &comma
  }) -> $i, $v {
      printf "%15s : %s\n", $i, $v
}
