sub postfix:<!> (Int $n) { (flat 1, [\*] 1..*)[$n] }

multi base (Int $n is copy, 'F', $length? is copy) {
    constant @fact = [\*] 1 .. *;
    my $i = $length // @fact.first: * > $n, :k;
    my $f;
    [ @fact[^$i].reverse.map: { ($n, $f) = $n.polymod($_); $f } ]
}

sub fpermute (@a is copy, *@f) { (^@f).map: { @a[$_ .. $_ + @f[$_]].=rotate(-1) }; @a }

put "Part 1: Generate table";
put $_.&base('F', 3).join('.') ~ ' -> ' ~ [0,1,2,3].&fpermute($_.&base('F', 3)).join for ^24;

put "\nPart 2: Compare 11! to 11! " ~ '¯\_(ツ)_/¯';
# This is kind of a weird request. Since we don't actually need to _generate_
# the permutations, only _count_ them: compare count of 11! vs count of 11!
put "11! === 11! : {11! === 11!}";

put "\nPart 3: Generate the given task shuffles";
my \Ω = <A♠ K♠ Q♠ J♠ 10♠ 9♠ 8♠ 7♠ 6♠ 5♠ 4♠ 3♠ 2♠ A♥ K♥ Q♥ J♥ 10♥ 9♥ 8♥ 7♥ 6♥ 5♥ 4♥ 3♥ 2♥
         A♦ K♦ Q♦ J♦ 10♦ 9♦ 8♦ 7♦ 6♦ 5♦ 4♦ 3♦ 2♦ A♣ K♣ Q♣ J♣ 10♣ 9♣ 8♣ 7♣ 6♣ 5♣ 4♣ 3♣ 2♣
>;

my @books = <
    39.49.7.47.29.30.2.12.10.3.29.37.33.17.12.31.29.34.17.25.2.4.25.4.1.14.20.6.21.18.1.1.1.4.0.5.15.12.4.3.10.10.9.1.6.5.5.3.0.0.0
    51.48.16.22.3.0.19.34.29.1.36.30.12.32.12.29.30.26.14.21.8.12.1.3.10.4.7.17.6.21.8.12.15.15.13.15.7.3.12.11.9.5.5.6.6.3.4.0.3.2.1
>;

put "Original deck:";
put Ω.join;

put "\n$_\n" ~ Ω[(^Ω).&fpermute($_.split: '.')].join for @books;

put "\nPart 4: Generate a random shuffle";
my @shoe = (+Ω … 2).map: { (^$_).pick };
put @shoe.join('.');
put Ω[(^Ω).&fpermute(@shoe)].join;

put "\nSeems to me it would be easier to just say: Ω.pick(*).join";
put Ω.pick(*).join;
