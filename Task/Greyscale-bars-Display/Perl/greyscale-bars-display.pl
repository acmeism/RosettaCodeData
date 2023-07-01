sub partition {
    my($all, $div) = @_;
    my @marks = 0;
    push @marks, $_/$div * $all for 1..$div;
    my @copy = @marks;
    $marks[$_] -= $copy[$_-1] for 1..$#marks;
    @marks[1..$#marks];
}

sub bars {
    my($h,$w,$p,$rev) = @_;
    my (@nums,@vals,$line,$d);

    $d  = 2**$p;
    push @nums, int $_/($d-1) * (2**16-1) for $rev ? reverse 0..$d-1 : 0..$d-1;
    push @vals, ($nums[$_]) x (partition($w, $d))[$_] for 0..$#nums;
    $line = join(' ', @vals) . "\n";
    $line x $h;
}

my($w,$h) = (1280,768);
open my $pgm, '>', 'Greyscale-bars-perl5.pgm' or die "Can't create Greyscale-bars-perl5.pgm: $!";

print $pgm <<"EOH";
P2
# Greyscale-bars-perl5.pgm
$w $h
65535
EOH

my ($h1,$h2,$h3,$h4) = partition($h,4);

print $pgm
    bars($h1,$w,3,0),
    bars($h2,$w,4,1),
    bars($h3,$w,5,0),
    bars($h4,$w,6,1);
