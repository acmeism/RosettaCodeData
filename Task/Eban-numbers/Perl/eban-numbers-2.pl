use strict;
use warnings;
use bigint;
use feature 'say';
use Lingua::EN::Nums2Words 'num2word';
use List::AllUtils 'sum';

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }

sub nban {
    my ($n, @numbers) = @_;
    grep { lc(num2word($_)) !~ /[$n]/i } @numbers;
}

sub enumerate {
    my ($n, $upto) = @_;
    my @ban = nban($n, 1 .. 99);
    my @orders;
    for my $o (2 .. $upto) {
        push @orders, [nban($n, map { $_ * 10**$o } 1 .. 9)];
    }
    for my $oom (@orders) {
        next unless +@$oom;
        my @these;
        for my $num (@$oom) {
            push @these, $num, map { $_ + $num } @ban;
        }
       push @ban, @these;
    }
    unshift @ban, 0 if nban($n, 0);
    @ban
}

sub count {
    my ($n, $upto) = @_;
    my @orders;
    for my $o (2 .. $upto) {
        push @orders, [nban($n, map { $_ * 10**$o } 1 .. 9)];
    }
    my @count = scalar nban($n, 1 .. 99);
    for my $o ( 0 .. $#orders - 1 ) {
        push @count, sum(@count) * (scalar @{$orders[$o]}) + (scalar @{$orders[$o]});
    }
    ++$count[0] if nban($n, 0);
    for my $m ( 0 .. $#count - 1 ) {
        next unless scalar $orders[$m];
        if (nban($n, 10**($m+2))) { $count[$m]++; $count[$m + 1]-- }
    }
    map { sum( @count[0..$_] ) } 0..$#count;
}

for my $t ('e') {
    my @bans  = enumerate($t, 4);
    my @count = count($t, my $max = 21);

    my @j = grep { $_ <= 10 } @bans;
    unshift @count, @{[1+$#j]};

    say "\n============= $t-ban: =============";
    my @a = grep { $_ <= 1000 } @bans;
    say "$t-ban numbers up to 1000: @{[1+$#a]}";
    say '[', join(' ',@a), ']';
    say '';

    my @b = grep { $_ >= 1000 && $_ <= 4000 } @bans;
    say "$t-ban numbers between 1,000 & 4,000 (inclusive): @{[1+$#b]}";
    say '[', join(' ',@b), ']';
    say '';

    say "Counts of $t-ban numbers up to ", lc(num2word(10**$max));

    for my $exp (1..$max) {
        my $nu = $count[$exp-1];
        printf "Up to and including %23s: %s\n", lc(num2word(10**$exp)), comma($nu);
    }
}
