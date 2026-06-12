use v5.36;
use Lingua::EN::Numbers qw(num2en_ordinal);

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }
sub table ($c, @V) { my $t = $c * (my $w = 5); ( sprintf( ('%'.$w.'d')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

sub updown ($n) {
    my($i,@ud);
    while (++$i) {
        next if subset($i, '0', 0) or 0 != ($i+reverse $i) % 10;
        my @i = split '', $i;
        next if grep { 10 != $i[$_] + $i[$#i-$_] } 0..$#i;
        push @ud, $i;
        last if $n == @ud;
    }
    @ud
}

my @ud = updown( 5000 );
say "First fifty upside-downs:\n" . table 10, @ud[0..49];
say ucfirst num2en_ordinal($_) . ': ' . comma $ud[$_-1] for 500, 5000;
