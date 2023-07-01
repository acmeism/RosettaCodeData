use v5.36;
use builtin <indexed floor>;
use experimental qw(builtin for_list);
use List::Util 'max';

sub table ($c, @V) { my $t = $c * (my $w = 2 + length max map { length } @V); ( sprintf( ('%'.$w.'s')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

sub polybius ($text) {
    my %p;
    my $n = floor sqrt length $text;
    for my($k,$v) (indexed split '', $text) {
        $p{$v} = join ' ', $k%$n, int $k/$n
    }
    %p;
}

sub encrypt ($text, %P) {
    my(%I, @c, $encrypted);
    for my($k,$v) (%P) { $I{$v} = $k }
    for my ($n,$char) (indexed split '', ($text =~ s/\s//gr)) {
        for my($m,$i) (indexed split ' ', $P{$char}) { $c[$m][$n] = $i }
    }
    for my($i,$j) ($c[1]->@*, $c[0]->@*) { $encrypted .= $I{"$j $i"} }
    $encrypted
}

sub decrypt ($text, %P) {
    my($decrypted, $l, %I, @c) = ('', length($text));
    for my($k,$v) (%P) { $I{$v} = $k }
    for (split '', $text) {
        for my($i,$j) (split ' ', $P{$_}) { unshift @c, $i, $j }
    }
    substr $decrypted, 0, 0, $I{ "$c[$_] $c[$_+$l]" } for 0 .. $l-1;
    $decrypted;
}

for my($polybius,$message) (
  join('','A'..'Z') =~ s/J//r,                 'ATTACK AT DAWN',
  'BGWKZQPNDSIOAXEFCLUMTHYVR',                 'FLEE AT ONCE',
  join('','_.', 'A'..'Z', 'a'..'z', '0'..'9'), 'The_invasion_will_start_on_the_first_of_January_2023.',
  ) {
    my %Ptable = polybius $polybius;
    say "\nUsing polybius:\n" . table sqrt length $polybius, split '', $polybius;
    say 'Message   : ' .  $message;
    say 'Encrypted : ' .  (my $encrypted = encrypt $message, %Ptable);
    say 'Decrypted : ' .  decrypt $encrypted, %Ptable;
}
