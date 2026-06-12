use strict; use warnings;
use feature <say postderef>;
use List::AllUtils 'max_by';
use Lingua::EN::Numbers 'num2en';

for my $limit (1e3, 1e4) {
    my(%E,@E);
    push $E{ join '', sort split '', num2en($_) }->@*, $_ for 0..$limit;
    for (keys %E) { delete $E{$_} if $E{$_}->@* < 2 }
    @E = sort { $a <=> $b } map { @$_ } values %E;

    say 'First 30 English cardinal anagrams:' . join ' ', @E[0..29] if $limit == 1e3;
    say "\nCount of English cardinal anagrams up to $limit: " . keys %E;
    say "\nLargest group(s) of English cardinal anagrams up to $limit";
    say join ' ', $E{$_}->@* for max_by {f $E{$_}->@* } keys %E;
}
