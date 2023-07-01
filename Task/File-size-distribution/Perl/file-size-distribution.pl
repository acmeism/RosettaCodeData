use File::Find;
use List::Util qw(max);

my %fsize;
$dir = shift || '.';
find(\&fsize, $dir);

$max = max($max,$fsize{$_}) for keys %fsize;
$total += $size while (undef,$size) = each %fsize;

print "File size distribution in bytes for directory: $dir\n";
for (0 .. max(keys %fsize)) {
    printf "# files @ %4sb %8s: %s\n", $_ ? '10e'.($_-1) : 0, $fsize{$_} // 0,
       histogram( $max, $fsize{$_} // 0, 80);
}
print "$total total files.\n";

sub histogram {
    my($max, $value, $width) = @_;
    my @blocks = qw<| ▏ ▎ ▍ ▌ ▋ ▊ ▉ █>;
    my $scaled = int $value * $width / $max;
    my $end =     $scaled % 8;
    my $bar = int $scaled / 8;
    my $B = $blocks[8] x ($bar * 8) . ($end ? $blocks[$end] : '');
}

sub fsize { $fsize{ log10( (lstat($_))[7] ) }++ }
sub log10 { my($s) = @_; $s ? int log($s)/log(10) : 0 }
