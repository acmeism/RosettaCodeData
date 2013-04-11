constant TRIALS = 1e4;

sub prob_choice_picker (%options is copy) {
  my $n = 0;
  $_ = ($n += $_) for values %options;
  return sub {
    my $r = rand;
    (first { $r < .value }, %options).key;
  };
}

my %ps = (
  (map {$^w => 1/$^n}, (5 .. 11 Z <aleph beth gimel daleth he waw zayin>)),
  heth => 0
);
%ps<heth> = 1 - [+] values %ps;

&picker = prob_choice_picker %ps;
my %results;
++%results{picker} for ^TRIALS;

say 'Event   Occurred  Expected  Difference';
for sort { .value }, %results {
    printf "%-6s  %f  %f  %f\n",
        .key, .value/TRIALS, %ps{.key},
        abs( .value/TRIALS - %ps{.key} );
}
