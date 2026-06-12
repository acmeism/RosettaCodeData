use strict;
use warnings;

my $max = 4; # records per merge file
my(@chunk,@tempf);

sub mysort ($$) { return $_[0] <=> $_[1] }

sub store {
    my($a) = @_;
    my $f = IO::File->new_tmpfile; # self-deleting after program exit
    print $f sort mysort @$a;
    seek $f, 0, 0 or warn "Oops: $!";
    push(@tempf, { fh => $f, queued => scalar <$f> } );
}

# read input and create sorted temporary files
while (<DATA>) {
    push @chunk, $_;
    store(\@chunk), @chunk = () if @chunk == $max;
}
store(\@chunk) if @chunk;

# merge everything
while (1) {
    my($lowest) = (sort { mysort($a->{queued}, $b->{queued}); } grep(defined $_->{queued}, @tempf) )[0];
    last unless $lowest->{queued};
    print $lowest->{queued};
    $lowest->{queued} = $lowest->{fh}->getline();
}

__DATA__
432
345
321
543
987
456
678
123
765
567
876
654
789
234
