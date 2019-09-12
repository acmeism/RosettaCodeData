binmode(STDOUT, ":utf8");
our @sparks=map {chr} 0x2581 .. 0x2588;
sub sparkline(@) {
    my @n=map {0+$_} grep {length} @_ or return "";
    my($min,$max)=($n[0])x2;
    if (@n>1) {
        for (@n[1..$#n]) {
            if    ($_<$min) { $min=$_ }
            elsif ($_>$max) { $max=$_ }
        }
    }
    my $sparkline="";
    for(@n) {
        my $height=int( $max==$min ? @sparks/2 : ($_-$min)/($max-$min)*@sparks );
        $height=$#sparks if $height>$#sparks;
        $sparkline.=$sparks[$height];
    }
    my $summary=sprintf "%d values; range %s..%s", scalar(@n), $min, $max;
    return wantarray ? ($summary, "\n", $sparkline, "\n") : $sparkline;
}

# one number per line
# print sparkline( <> );

# in scalar context, get just the sparkline without summary or trailing newline
# my $sl=sparkline( <> ); print $sl;

# one sparkline per line
print sparkline( split /[\s,]+/ ) while <>;
