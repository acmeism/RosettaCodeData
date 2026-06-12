use strict;
use warnings;
use feature 'say';

sub filter {
    my($text) = @_;
    if (length($text)>1 and $text eq reverse $text) {
        return 1, 'Palindromic';
    } elsif (0 == length(($text =~ s/\B..*?\b ?//gr) =~ s/^(.)\1+//r)) {
        return 1, 'Alliterative';
    }
    return 0, 'Does not compute';
}

for my $text ('otto', 'ha ha', 'a', 'blue skies', 'tiptoe through the tulips', 12321) {
    my($status,$message) = analyze $text;
    printf "%s $message\n", $status ? 'Yes' : 'No ';
}
