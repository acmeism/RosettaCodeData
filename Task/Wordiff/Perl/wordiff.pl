use strict;
use warnings;
use feature 'say';
use List::Util 'min';

my %cache;
sub leven {
    my ($s, $t) = @_;
    return length($t) if $s eq '';
    return length($s) if $t eq '';
    $cache{$s}{$t} //=
      do {
        my ($s1, $t1) = (substr($s, 1), substr($t, 1));
        (substr($s, 0, 1) eq substr($t, 0, 1))
          ? leven($s1, $t1)
          : 1 + min(
                    leven($s1, $t1),
                    leven($s,  $t1),
                    leven($s1, $t ),
            );
      };
}

print "What is your name?"; my $name = <STDIN>;
$name = 'Number 6';
say "What is your quest? Never mind that, I will call you '$name'";
say 'Hey! I am not a number, I am a free man!';

my @starters = grep { length() < 6 } my @words = grep { /.{2,}/ } split "\n", `cat unixdict.txt`;

my(%used,@possibles,$guess);
my $rounds = 0;
my $word = say $starters[ rand $#starters ];

while () {
    say "Word in play: $word";
    $used{$word} = 1;
    @possibles = ();
    for my $w (@words) {
        next if abs(length($word) - length($w)) > 1;
        push @possibles, $w if leven($word, $w) == 1 and ! defined $used{$w};
    }
    print "Your word? "; $guess = <STDIN>;  chomp $guess;
    last unless grep { $guess eq $_ } @possibles;
    $rounds++;
    $word = $guess;
}

my $already = defined $used{$guess} ? " '$guess' was already played but" : '';

if (@possibles) { say "\nSorry $name,${already} one of <@possibles> would have continued the game." }
else            { say "\nGood job $name,${already} there were no possible words to play."                }
say "You made it through $rounds rounds.";
