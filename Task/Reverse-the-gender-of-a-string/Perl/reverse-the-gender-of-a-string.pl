my %swaps = (
    'she'  => 'he',
    'his'  => 'her',
);

$swaps{         $swaps{$_} } =         $_ for keys %swaps; # inverted pairs
$swaps{ ucfirst $swaps{$_} } = ucfirst $_ for keys %swaps; # title-case version

sub gender_swap {
    my($s) = @_;
    $s =~ s/\b$_\b/_$swaps{$_}/g for keys %swaps; # swap and add guard character
    $s =~ s/_//g;                                 # remove guard
    $s;
}

$original = qq{She was this soul sherpa. She took his heart! They say she's going to put me on a shelf.\n};
print $swapped  = gender_swap($original);
print $reverted = gender_swap($swapped);
