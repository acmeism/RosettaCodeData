use strict;
use warnings;
use feature 'say';
use List::Util <min max>;

my(%encode,%decode,@table);

sub build {
    my($u,$v,$alphabet) = @_;
    my(@flat_board,%p2c,%c2p);
    my $numeric_escape = '/';

    @flat_board = split '', uc $alphabet;
    splice @flat_board, min($u,$v), 0, undef;
    splice @flat_board, max($u,$v), 0, undef;

    push @table, [' ', 0..9];
    push @table, [' ', map { defined $_ ? $_ : ' '} @flat_board[ 0 ..  9] ];
    push @table, [$u,  @flat_board[10 .. 19]];
    push @table, [$v,  @flat_board[20 .. 29]];

    my @nums = my @order = 0..9;
    push @nums, (map { +"$u$_" } @order), map { +"$v$_" } @order;

    @c2p{@nums} = @flat_board;
    for (keys %c2p) { delete $c2p{$_} unless defined $c2p{$_} }
    @p2c{values %c2p} = keys %c2p;
    $p2c{$_} = $p2c{$numeric_escape} . $_ for 0..9;
    while (my ($k, $v) = each %p2c) {
        $encode{$k} = $v;
        $decode{$v} = $k unless $k eq $numeric_escape;
    }
}

sub decode {
    my($string) = @_;
    my $keys = join '|', keys %decode;
    $string =~ s/($keys)/$decode{$1}/gr;
}

sub encode {
    my($string) = uc shift;
    $string =~ s#(.)#$encode{$1} // $encode{'.'}#ger;
}

my $sc = build(3, 7, 'HOLMESRTABCDFGIJKNPQUVWXYZ./');
say join  ' ', @$_ for @table;
say '';
say 'Original: ', my $original = 'One night-it was on the twentieth of March, 1888-I was returning';
say 'Encoded:  ', my $en = encode($original);
say 'Decoded:  ', decode($en);
