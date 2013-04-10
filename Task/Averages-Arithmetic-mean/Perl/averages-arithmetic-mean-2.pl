use Data::Average;

my $d = Data::Average->new;
$d->add($_) foreach qw(3 1 4 1 5 9);
print $d->avg, "\n";
