use strict;
use warnings;

sub show {
    # print the given string, but convert certain non-printable characters to be visible:
    #  newline -> \n
    #  null \0 -> !
    #  control-A \1 -> ?
    #  control-B \2 -> _
    local $_ = shift;
    s/\n/\\n/g;
    s/\0/!/g;
    s/\01/?/g;
    s/\02/_/g;
    print "$_\n";
}

for my $test ( ["ALLOW", "LOLLY"],
               ["BULLY", "LOLLY"],
               ["ROBIN", "ALERT"],
               ["ROBIN", "SONIC"],
               ["ROBIN", "ROBIN"] )
{
    print "-" x 80, "\n";

    # @$test is two strings.
    # my ($answer, $guess) = @$test

    print "Start\n";
    local $_ = join "\n", @$test;
    show "  '$_'";

    show "Same letter, same position -> \0";
    # For each letter in $answer that also appears in $guess, change the
    # letter to a null character \0.
    #
    # [ -~] matches any letter (any printable character, not \0 or \n).
    #       Could also have used [A-Z]
    #
    # $` the substring before the matched letter
    #
    # tr!!.!cr
    #   !! the set of characters to transliterate (i.e., the empty set)
    #   c - complement the empty set (i.e., all characters)
    #   r - non-destructive: don't modify $` instead just return the resulting string
    #   !.! - change every character of $` to a dot '.'
    #   Could also have used "." x length($`)
    #
    # (??xxx) - use the result of the Perl expression xxx as a regex pattern,
    #    xxx will be some number of dots,
    #    one dot for every character before the matched letter.
    #    (A dot matches any character except newline \n.)
    #
    # \1 matches the same letter again.
    # Results in something like s/(X)(.*\n...)X/\0$2\0/
    #
    # i.e., if letter X from $answer appears in the same position in $guess,
    # then change X to a null character \0 in both $answer and $guess.
    show "  '$_'"
        while s/([ -~])(.*\n(??{$` =~ tr!!.!cr}))\1/\0$2\0/;

    show "Same letter, any position -> \1";
    # [ -~] matches any remaining letter in $answer (again could have used [A-Z]).
    #
    # .*\n anything in $answer after the letter.
    #
    # .*?\1 anything in $guess up to (and including) that same letter.
    # \1 matches whatever letter ([ -~]) matched.
    # The ? causes us to select the left-most occurrence of the letter in
    # $answer (in case there are multiple occurrences).
    #
    # Change that letter to control-A \01 in both $answer and $guess.
    #
    # i.e., if letter X from $answer appears anywhere in $guess, then change X
    # to control-A in both $answer and $guess.
    show "  '$_'"
        while s/([ -~])(.*\n.*?)\1/\01$2\01/;

    print "Discard first word\n";
    # s/.*\n//r
    #   r - non-destructive (return the result without modifying $_)
    s/.*\n//;
    show "  '$_'";

    show "Remaining letters -> \2";
    # tr/\0\1/\2/cr
    #   /\0\1/ - the set of chars to transliterate: \0 null and \1 control-A
    #   c - complement the set of chars (i.e., any char that's not null or control-A)
    #   r - non-destructive
    tr/\0\1/\2/c;
    show "  '$_'";

    # In general: split //, "XYZ" - returns a list ("X", "Y", "Z").
    # Here: split // - returns a string of chars all "\0" or "\1" or "\2".
    my @chars = split //, $_;
    show "  @chars";

    # Change "\0" to integer 0, "\1" to 1, "\2" to 2
    my @indexes = map ord, @chars;
    show "  @indexes";

    # Convert indexes 0-2 to color names.
    my @colors = qw( green yellow grey );
    print "@$test => @{ [ @colors[ @indexes ] ] }\n";
    #print "@$test => @colors[ @indexes ]\n"; # same
}
