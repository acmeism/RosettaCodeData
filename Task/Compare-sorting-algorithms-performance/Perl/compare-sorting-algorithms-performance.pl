# 20241006 Perl programming solution

use strict;
use warnings;
use Time::HiRes qw(time);

my ($rounds, $size) = (3, 2000);
my @allones         = (1) x $size;
my @sequential      = (1 .. $size);
my @randomized      = map { $sequential[rand @sequential] } 1 .. $size;

sub insertion_sort {
    my @a = @_;
    for my $k (1 .. $#a) {
        my ($j, $value) = ($k - 1, $a[$k]);
        while ($j >= 0 && $a[$j] > $value) {
            $a[$j + 1] = $a[$j];
            $j--;
        }
        $a[$j + 1] = $value;
    }
    return @a;
}

sub merge_sort {
    my @a = @_;
    return @a if @a <= 1;

    my $m = int(@a / 2);
    my @l = merge_sort(@a[0 .. $m - 1]);
    my @r = merge_sort(@a[$m .. $#a]);

    return (@l, @r) if $l[-1] <= $r[0];

    my @result;
    while (@l && @r) {
        push @result, $l[0] <= $r[0] ? shift @l : shift @r;
    }
    push @result, @l, @r;
    return @result;
}

sub quick_sort {
    my @data = @_;
    return @data if @data <= 1;

    my $pivot_index = int(rand(@data));
    my $pivot = $data[$pivot_index];

    @data = grep { $_ != $pivot } @data;

    my (@left, @right);
    foreach my $x (@data) {
        $x < $pivot ? push @left, $x : push @right, $x;
    }
    return (quick_sort(@left), $pivot, quick_sort(@right));
}

sub comparesorts {
    my ($rounds, @tosort) = @_;
    my ($iavg, $mavg, $qavg);

    foreach my $sort_type (('i', 'm', 'q') x $rounds) {
        my @data_copy = @tosort;
        my $t = time;
        if ($sort_type eq 'i') {
            insertion_sort(@data_copy);
            $iavg += time - $t;
        } elsif ($sort_type eq 'm') {
            merge_sort(@data_copy);
            $mavg += time - $t;
        } elsif ($sort_type eq 'q') {
            quick_sort(@data_copy);
            $qavg += time - $t;
        }
    }
    return ($iavg / $rounds, $mavg / $rounds, $qavg / $rounds);
}

foreach my $test (['ones', @allones], ['presorted', @sequential], ['randomized', @randomized]) {
    my ($t, @d) = @$test;
    print "Average sort times for $size $t:\n";
    my ($i_time, $m_time, $q_time) = comparesorts($rounds, @d);
    printf "insertion sort      %0.9f\n", $i_time;
    printf "merge sort          %0.9f\n", $m_time;
    printf "quick sort          %0.9f\n", $q_time;
}
