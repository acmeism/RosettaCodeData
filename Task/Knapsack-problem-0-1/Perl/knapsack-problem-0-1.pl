my $raw = <<'TABLE';
map			9	150
compass			13	35
water			153	200
sandwich		50	160
glucose			15	60
tin			68	45
banana			27	60
apple			39	40
cheese			23	30
beer			52	10
suntancream		11	70
camera			32	30
T-shirt			24	15
trousers		48	10
umbrella		73	40
waterproof trousers	42	70
waterproof overclothes	43	75
note-case		22	80
sunglasses		7	20
towel			18	12
socks			4	50
book			30	10
TABLE

my (@name, @weight, @value);
for (split "\n", $raw) {
        for ([ split /\t+/ ]) {
                push @name,  $_->[0];
                push @weight, $_->[1];
                push @value,  $_->[2];
        }
}

my $max_weight = 400;
my @p = (map([[0, []], map undef, 0 .. $max_weight], 0 .. $#name),
        [ map([0, []], 0 .. $max_weight + 1)]);

sub optimal {
        my ($i, $w) = @_;

        if (!defined $p[$i][$w]) {
                if ($weight[$i] > $w) {
                        $p[$i][$w] = optimal($i - 1, $w)
                } else {
                        my $x = optimal($i - 1, $w);
                        my $y = optimal($i - 1, $w - $weight[$i]);

                        if ($x->[0] > $y->[0] + $value[$i]) {
                                $p[$i][$w] = $x
                        } else {
                                $p[$i][$w] = [  $y->[0] + $value[$i],
                                                [ @{$y->[1]}, $name[$i] ]]
                        }
                }
        }
        return $p[$i][$w]
}

my $sol = optimal($#name, $max_weight);
print "$sol->[0]: @{$sol->[1]}\n";

# prints:
# 1030: map compass water sandwich glucose banana suntancream waterproof trousers
#         waterproof overclothes note-case sunglasses socks
