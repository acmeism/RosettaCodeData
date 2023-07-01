#!/usr/bin/perl

my @a = (4, 65, 2, -31, 0, 99, 2, 83, 782, 1);
print "@a\n";
heap_sort(\@a);
print "@a\n";

sub heap_sort {
    my ($a) = @_;
    my $n = @$a;
    for (my $i = ($n - 2) / 2; $i >= 0; $i--) {
        down_heap($a, $n, $i);
    }
    for (my $i = 0; $i < $n; $i++) {
        my $t = $a->[$n - $i - 1];
        $a->[$n - $i - 1] = $a->[0];
        $a->[0] = $t;
        down_heap($a, $n - $i - 1, 0);
    }
}

sub down_heap {
    my ($a, $n, $i) = @_;
    while (1) {
        my $j = max($a, $n, $i, 2 * $i + 1, 2 * $i + 2);
        last if $j == $i;
        my $t = $a->[$i];
        $a->[$i] = $a->[$j];
        $a->[$j] = $t;
        $i = $j;
    }
}

sub max {
    my ($a, $n, $i, $j, $k) = @_;
    my $m = $i;
    $m = $j if $j < $n && $a->[$j] > $a->[$m];
    $m = $k if $k < $n && $a->[$k] > $a->[$m];
    return $m;
}
