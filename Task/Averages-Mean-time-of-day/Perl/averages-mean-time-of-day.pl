use Const::Fast;
const my $SECONDS_IN_HOUR   => 60 * 60;
const my $SECONDS_IN_MINUTE => 60;

sub hms_2_seconds {
    my ( $hms ) = @_;
    my ( $h, $m, $s ) = split /:/, $hms;
    $h += 24 if $h < 12;
    return $s + $m * $SECONDS_IN_MINUTE + $h * $SECONDS_IN_HOUR;
}
sub seconds_2_hms {
    my ( $seconds ) = @_;

    my ( $h, $m );

    $h = int( $seconds / $SECONDS_IN_HOUR );
    $seconds = $seconds % $SECONDS_IN_HOUR;

    $m = int( $seconds / $SECONDS_IN_MINUTE );
    $seconds = $seconds % $SECONDS_IN_MINUTE;

    return sprintf "%02s:%02s:%02s", $h, $m, $seconds;
}

my @hms = split /,\s+/, scalar <STDIN>;

my ($sum, $count);
for my $time ( @hms) {
    $sum += hms_2_seconds $time;
    $count++;
}
say seconds_2_hms int( $sum / $count );
