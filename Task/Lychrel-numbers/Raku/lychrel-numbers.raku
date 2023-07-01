my %lychrels;
my @seeds;
my @palindromes;
my $count;
my $max = 500;
my $limit = '10_000';
my %seen;

for 1 .. $limit -> $int {
    my @test;
    my $index = 0;
    if $int.&is-lychrel {
        %lychrels.push: ($int => @test).invert;
        @palindromes.push: $int if $int == $int.flip;
        $count++;
    }

    sub is-lychrel (Int $l) {
        if  %seen{$l} or $index++ > $max {
            %seen{$_} = True for @test;
            return True;
        }
        @test.push: my $m = $l + $l.flip;
        return False if $m == $m.flip;
        $m.&is-lychrel;
    }
}

for %lychrels{*}»[0].unique.sort -> $ly {
    my $next = False;
    for %lychrels -> $l {
        for $l.value[1..*] -> $lt {
            $next = True and last if $ly == $lt;
            last if $ly < $lt;
        }
        last if $next;
    }
    next if $next;
    @seeds.push: $ly;
}

say "   Number of Lychrel seed numbers < $limit: ", +@seeds;
say "             Lychrel seed numbers < $limit: ", join ", ", @seeds;
say "Number of Lychrel related numbers < $limit: ", +$count - @seeds;
say "    Number of Lychrel palindromes < $limit: ", +@palindromes;
say "              Lychrel palindromes < $limit: ", join ", ", @palindromes;
