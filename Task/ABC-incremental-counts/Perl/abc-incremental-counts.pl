sub abc_incremental {
    my ($set, $s, $limit) = @_;
    die 'Set has to contain 3 letters' if @$set != 3;
    my %c = map {$_ => 0} @$set;
    $c{$_}++ for split //, $s =~ s/[^@$set]//gr;
    my @counts = sort values %c;
    return 0 if $counts[0] < ($limit // 1);
    for (1..$#counts) {
        return 0 unless $counts[$_] == $counts[$_-1] + 1;
    }
    return 1;
}

my @sets = ([qw<a b c>], [qw<t h e>], [qw<c i o>]);
my @limits = (1, 1, 2);
my %words = map { $_ => [] } 0..2;

open(my $fh, 'unixdict.txt');
my @words = <$fh>;
for my $word (@words) {
    $word =~ s/\s//g;
    for (0..$#sets) {
        push @{$words{$_}}, $word if abc_incremental($sets[$_], $word, $limits[$_]);
    }
}
close $fh;

for (0..$#sets) {
    print "@{$sets[$_]}:\n";
    print join(' ', @{$words{$_}}), "\n";
}
