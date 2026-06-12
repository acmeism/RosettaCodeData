use strict;
use warnings;

my %card;
$card{a} = { name => 'Alberta Clipper',       sex => 'M', rating => 100 };
$card{b} = { name => 'Beetlebaum',            sex => 'F', rating => $card{a}{rating} -  8 -  2*2     };
$card{c} = { name => 'Canyonero',             sex => 'M', rating => $card{a}{rating} +  4 -  2*3.5   };
$card{d} = { name => 'Donnatello',            sex => 'F', rating => $card{a}{rating} -  4 - 10*0.4   };
$card{e} = { name => 'Exterminator',          sex => 'M', rating => $card{d}{rating} +  7 -  2*1     };
$card{f} = { name => 'Frequent Flyer',        sex => 'M', rating => $card{d}{rating} + 11 -  2*(4-2) };
$card{g} = { name => 'Grindstone',            sex => 'M', rating => $card{a}{rating} - 10 + 10*0.2   };
$card{h} = { name => 'His Honor',             sex => 'M', rating => $card{g}{rating} +  6 -  2*1.5   };
$card{i} = { name => 'Iphigenia in Brooklyn', sex => 'F', rating => $card{g}{rating} + 15 -  2*2     };
$card{j} = { name => 'Josephine',             sex => 'F' };

# adjustments to ratings for current race
$card{b}{rating} += 4;
$card{c}{rating} -= 4;
$card{h}{rating} += 3;
$card{j}{rating} = $card{a}{rating} - 3 + 10*0.2;

# initialize carry weights
for (keys %card) {
    $card{$_}{rating} += 3 if $card{$_}{sex} eq 'F';
    $card{$_}{weight} = $card{$_}{sex} eq 'M' ? 9.00 : 8.11
}

print "Pos Horse         Name           Weight   Back    Sex    Time\n";

my($previous, $position, $leader, @predictions) = 0;
for (sort { $card{$b}{rating} <=> $card{$a}{rating} } keys %card) {
    $leader = $_ unless $leader;
    ++$position if $previous != $card{$_}{rating};
    $previous = $card{$_}{rating};
    $card{$_}{back} = ($card{$leader}{rating} - $card{$_}{rating}) / 2;
    $card{$_}{time} = 96 - ($card{$_}{rating} - 100) / 10;
    push @predictions, sprintf "%2d    %s   %-22s  %.2f    %.1f    %-6s %s\n", $position, $_, $card{$_}{name}, $card{$_}{weight},
      $card{$_}{back}, $card{$_}{sex} eq 'M' ? 'colt' : 'filly', sprintf '%1d:%.1f', int($card{$_}{time}/60), $card{$_}{time}-60;
}

print for sort @predictions;
