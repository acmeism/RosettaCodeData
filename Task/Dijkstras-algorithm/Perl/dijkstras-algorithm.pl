use strict;
use warnings;
use constant True => 1;

sub add_edge {
    my ($g, $a, $b, $weight) = @_;
    $g->{$a} ||= {name => $a};
    $g->{$b} ||= {name => $b};
    push @{$g->{$a}{edges}}, {weight => $weight, vertex => $g->{$b}};
}

sub push_priority {
    my ($a, $v) = @_;
    my $i = 0;
    my $j = $#{$a};
    while ($i <= $j) {
        my $k = int(($i + $j) / 2);
        if ($a->[$k]{dist} >= $v->{dist}) { $j = $k - 1 }
        else                              { $i = $k + 1 }
    }
    splice @$a, $i, 0, $v;
}

sub dijkstra {
    my ($g, $a, $b) = @_;
    for my $v (values %$g) {
        $v->{dist} = 10e7; # arbitrary large value
        delete @$v{'prev', 'visited'}
     }
    $g->{$a}{dist} = 0;
    my $h = [];
    push_priority($h, $g->{$a});
    while () {
        my $v = shift @$h;
        last if !$v or $v->{name} eq $b;
        $v->{visited} = True;
        for my $e (@{$v->{edges}}) {
            my $u = $e->{vertex};
            if (!$u->{visited} && $v->{dist} + $e->{weight} <= $u->{dist}) {
                $u->{prev} = $v;
                $u->{dist} = $v->{dist} + $e->{weight};
                push_priority($h, $u);
            }
        }
    }
}

my $g = {};
add_edge($g, @$_) for
 (['a', 'b',  7], ['a', 'c',  9], ['a', 'f', 14],
  ['b', 'c', 10], ['b', 'd', 15], ['c', 'd', 11],
  ['c', 'f',  2], ['d', 'e',  6], ['e', 'f',  9]);

dijkstra($g, 'a', 'e');

my $v = $g->{e};
my @a;
while ($v) {
    push @a, $v->{name};
    $v = $v->{prev};
}
my $path = join '', reverse @a;
print "$g->{e}{dist} $path\n";
