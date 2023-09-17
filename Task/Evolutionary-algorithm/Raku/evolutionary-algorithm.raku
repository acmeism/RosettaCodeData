constant target = "METHINKS IT IS LIKE A WEASEL";
constant @alphabet = flat 'A'..'Z',' ';
constant C = 10;

sub mutate(Str $string, Real $mutate-chance where 0 ≤ * < 1) {
  $string.subst: /<?{ rand < $mutate-chance }> . /, @alphabet.pick, :global
}
sub fitness(Str $string) { [+] $string.comb Zeq target.comb }

printf "\r%6d: '%s'", $++, $_ for
  @alphabet.roll(target.chars).join,
  { max :by(&fitness), mutate($_, .001) xx C } ... target;
print "\n";
