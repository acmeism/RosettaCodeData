#!/usr/bin/perl

my $min = 1;
my $max = 99;

print "=>> Think of a number between $min and $max and I'll guess it!\n
Press <ENTER> when are you ready... ";

<STDIN>;

my $guess = int(rand $max) + $min;
my $tries = 0;

sub question {
    my $guess = shift();
    print "\n=>> My guess is: $guess. Is your number higher, lower or equal? (h/l/e)\n> ";
    ++$tries;
}

question $guess;

while (1) {
    my $score = <STDIN>;

    if (lc substr($score, 0, 1) eq 'h') {
        $min = $guess + 1;
    }
    elsif (lc substr($score, 0, 1) eq 'l') {
        $max = $guess;
    }
    elsif (lc substr($score, 0, 1) eq 'e') {
        print "\nI knew it! It took me only $tries tries.\n";
        last;
    }
    else {
        print "error: invalid score\n";
    }

    print "\nI gave up...\n" and last if $max <= $min;

    $guess = int(($max + $min) / 2);

    question $guess;
}
