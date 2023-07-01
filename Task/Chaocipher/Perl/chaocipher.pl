use strict;
use warnings;
my(@left,@right,$e_msg,$d_msg);

sub init {
    @left  = split '', 'HXUCZVAMDSLKPEFJRIGTWOBNYQ';
    @right = split '', 'PTLNBQDEOYSFAVZKGJRIHWXUMC';
}

sub encode {
    my($letter) = @_;
    my $index = index join('', @right), $letter;
    my $enc   = $left[$index];
    left_permute($index);
    right_permute($index);
    $enc
}

sub decode {
    my($letter) = @_;
    my $index = index join('', @left), $letter;
    my $dec   = $right[$index];
    left_permute($index);
    right_permute($index);
    $dec
}

sub right_permute {
    my($index) = @_;
    rotate(\@right, $index + 1);
    rotate(\@right, 1, 2, 13);
}

sub left_permute {
    my($index) = @_;
    rotate(\@left, $index);
    rotate(\@left, 1, 1, 13);
}

sub rotate {
    my @list = @{ shift() };
    my($n,$s,$e) = @_;
    $s ? @list[0..$s-1, $s+$n..$e+$n-1, $s..$s+$n-1, $e+1..$#list]
       : @list[$n..$#list, 0..$n-1]
}

init; $e_msg .= encode $_ for split '', 'WELLDONEISBETTERTHANWELLSAID';
init; $d_msg .= decode $_ for split '', $e_msg;

print "$e_msg\n$d_msg\n";
