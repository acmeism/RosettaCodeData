use Lingua::EN::Numbers;

sub nban ($seq, $n = 'e') { ($seq).map: { next if .&cardinal.contains(any($n.lc.comb)); $_ } }

sub enumerate ($n, $upto) {
    my @ban = [nban(1 .. 99, $n)],;
    my @orders;
    (2 .. $upto).map: -> $o {
        given $o % 3 { # Compensate for irregulars: 11 - 19
            when 1  { @orders.push: [flat (10**($o - 1) X* 10 .. 19).map(*.&nban($n)), |(10**$o X* 2 .. 9).map: *.&nban($n)] }
            default { @orders.push: [flat (10**$o X* 1 .. 9).map: *.&nban($n)] }
        }
    }
    ^@orders .map: -> $o {
        @ban.push: [] and next unless +@orders[$o];
        my @these;
        @orders[$o].map: -> $m {
            @these.push: $m;
            for ^@ban -> $b {
                next unless +@ban[$b];
                @these.push: $_ for (flat @ban[$b]) »+» $m ;
            }
        }
        @ban.push: @these;
    }
    @ban.unshift(0) if nban(0, $n);
    flat @ban.map: *.flat;
}

sub count ($n, $upto) {
    my @orders;
    (2 .. $upto).map: -> $o {
        given $o % 3 { # Compensate for irregulars: 11 - 19
            when 1  { @orders.push: [flat (10**($o - 1) X* 10 .. 19).map(*.&nban($n)), |(10**$o X* 2 .. 9).map: *.&nban($n)] }
            default { @orders.push: [flat (10**$o X* 1 .. 9).map: *.&nban($n)] }
        }
    }
    my @count  = +nban(1 .. 99, $n);
    ^@orders .map: -> $o {
        @count.push: 0 and next unless +@orders[$o];
        my $prev = so (@orders[$o].first( { $_ ~~ /^ '1' '0'+ $/ } ) // 0 );
        my $sum = @count.sum;
        my $these = +@orders[$o] * $sum + @orders[$o];
        $these-- if $prev;
        @count[1 + $o] += $these;
        ++@count[$o]  if $prev;
    }
    ++@count[0] if nban(0, $n);
    [\+] @count;
}

#for < e o t tali subur tur ur cali i u > -> $n { # All of them
for < e t subur > -> $n { # An assortment for demonstration
    my $upto   = 21; # 1e21
    my @bans   = enumerate($n, 4);
    my @counts = count($n, $upto);

    # DISPLAY
    my @k = @bans.grep: * < 1000;
    my @j = @bans.grep: 1000 <= * <= 4000;
    put "\n============= {$n}-ban: =============\n" ~
        "{$n}-ban numbers up to 1000: {+@k}\n[{@k».&comma}]\n\n" ~
        "{$n}-ban numbers between 1,000 & 4,000: {+@j}\n[{@j».&comma}]\n" ~
        "\nCounts of {$n}-ban numbers up to {cardinal 10**$upto}"
        ;

    my $s = max (1..$upto).map: { (10**$_).&cardinal.chars };
    @counts.unshift: @bans.first: * > 10, :k;
    for ^$upto -> $c {
        printf "Up to and including %{$s}s: %s\n", cardinal(10**($c+1)), comma(@counts[$c]);
    }
}
