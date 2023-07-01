use ntheory qw(euler_phi);

sub phi_iter {
    my($p) = @_;
    euler_phi($p) + ($p == 2 ? 0 : phi_iter(euler_phi($p)));
}

my @perfect;
for (my $p = 2; @perfect < 20 ; ++$p) {
    push @perfect, $p if $p == phi_iter($p);
}

printf "The first twenty perfect totient numbers:\n%s\n", join ' ', @perfect;
