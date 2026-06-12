use strict;
use warnings;
use feature 'say';
use utf8;
binmode STDOUT, ':utf8';

sub conjugate {
    my($verb) = shift;
    join "\n", map { $verb . $_ } qw<ō ās at āmus ātis ant>;
}

for my $infinitive ('amāre', 'dare') {
    say "\nPresent active indicative conjugation of infinitive $infinitive.";
    my($verb) = $infinitive =~ /^ (\w+) [aā] re $/x;
    say $verb ? conjugate $verb : "Sorry, don't know how to conjugate $infinitive";
}
