use String::Splice:ver<0.0.3+>;

my $line = 80;

my $haystack = [~] <A C G T>.roll($line * 8);

say 'Needle: ' ~ my $needle = [~] <A C G T>.roll(4);

my $these = $haystack ~~ m:g/<$needle>/;

my @match = $these.map: { .from, .pos }

printf "From: %3s to %3s\n", |$_ for @match;

my $disp = $haystack.comb.batch($line)».join.join("\n");

for @match.reverse {
    $disp.=&splice(.[1] + .[1] div $line, "\e[0m" );
    $disp.=&splice(.[0] + .[0] div $line, "\e[31m");
}

say $disp;
