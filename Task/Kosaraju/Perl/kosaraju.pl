use strict;
use warnings;
use feature 'say';

sub kosaraju {
    our(%k) = @_;
    our %g = ();
    our %h;
    my $i = 0;
    $g{$_}     = $i++ for sort keys %k;
    $h{$g{$_}} = $_   for      keys %g; # invert

    our(%visited, @stack, @transpose, @connected);
    sub visit {
        my($u) = @_;
        unless ($visited{$u}) {
            $visited{$u} = 1;
            for my $v (@{$k{$u}}) {
                visit($v);
                push @{$transpose[$g{$v}]}, $u;
            }
            push @stack, $u;
        }
    }

    sub assign {
        my($u, $root) = @_;
        if ($visited{$u}) {
            $visited{$u} = 0;
            $connected[$g{$u}] = $root;
            assign($_, $root) for @{$transpose[$g{$u}]};
        }
    }

    visit($_) for sort keys %g;
    assign($_, $_) for reverse @stack;

    my %groups;
    for my $i (0..$#connected) {
        my $id = $g{$connected[$i]};
        push @{$groups{$id}}, $h{$i};
    }
    say join ' ', @{$groups{$_}} for sort keys %groups;
}

my %test1 = (
    0 => [1],
    1 => [2],
    2 => [0],
    3 => [1, 2, 4],
    4 => [3, 5],
    5 => [2, 6],
    6 => [5],
    7 => [4, 6, 7]
);

my %test2 = (
   'Andy' => ['Bart'],
   'Bart' => ['Carl'],
   'Carl' => ['Andy'],
   'Dave' => [<Bart Carl Earl>],
   'Earl' => [<Dave Fred>],
   'Fred' => [<Carl Gary>],
   'Gary' => ['Fred'],
   'Hank' => [<Earl Gary Hank>]
);

kosaraju(%test1);
say '';
kosaraju(%test2);
