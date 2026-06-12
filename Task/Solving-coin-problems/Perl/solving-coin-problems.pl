use strict;
use warnings;

use List::Util qw(sum uniq);
use File::Temp qw(tempfile);

my %nums = (
        zero        => 0,   one       => 1,     two      => 2,    three    => 3,
        four        => 4,   five      => 5,     six      => 6,    seven    => 7,
        eight       => 8,   nine      => 9,     ten      => 10,   eleven   => 11,
        twelve      => 12,  thirteen  => 13,    fourteen => 14,   fifteen  => 15,
        sixteen     => 16,  seventeen => 17,    eighteen => 18,   nineteen => 19,
        twenty      => 20,
);

my $decimal = qr/(?:[1-9][0-9]*\.?[0-9]*)|(?:0?\.[0-9]+)/;

while (<DATA>) {
    chomp;
    next if /^\s*$/ or /^\s*#.*$/; # skip blank and comment lines

    my($count, $total) = (0, 0);
    our @words = our @eqns = our @vars = our @types = ();

    sub add_type {
        my($type,$value) = @_;
        push @vars, "v_$type: $value";
        push @types, $type;
    }

    # Step 1: standardize language

    s/-/ /g;                       # convert hyphens to spaces
    $_ = lc($_);                   # convert to lower case

    # tokenize sentence boundaries, punctuation, symbols
    s/([\.\?\!]) / $1\n/g;
    s/([\.\?\!])$/ $1\n/g;
    s/\$(.)/\$ $1/g;               # prefix
    s/(.)([\;\:\%',¢])/$1 $2/g;    # suffix

    # fractions/multipliers
    s/half.dollars?/half_dollar/g;
    s/\b(one )?half\b/0.5/g;
    s/\btwice\b/two times/g;

    # convert English number-names to numbers
    foreach my $key (keys %nums) { s/\b$key\b/$nums{$key}/eg }

    # remove plurals
    s/(quarter|dime|nickel|dollar|coin|bill)s/$1/g;
    s/pennies/penny/g;

    # misc
    s/dollar coin/dollar_coin/g;
    s/(\d+) dollar\b/\$ $1/g;
    s/((?:\d+ )*\d+)/sum(split(' ',$1))/eg;

    # remove non-essential words
    s/\b(the|a|to|of|i|is|that|it|on|you|this|for|but|with|are|have|be|at|or|was|so|if|out|not|he|she|they|has|do|did|does)\b\s*//g;

    # Step 2: assign numeric values to terms

    add_type('dollar_coin',100) if /dollar_coin/;
    add_type('half_dollar',50)  if /half_dollar/;
    add_type('quarter',25)      if /quarter/;
    add_type('dime',10)         if /dime/;
    add_type('nickel',5)        if /nickel/;
    add_type('penny',1)         if /penny/;
    add_type($1, 100 * $1) while /\$ (\d+) bill/g;

    # Step 3: determine algebraic relationships

    while (/($decimal) (?:times )?as many \$ (\d+) bill as \$ (\d+) bill/g) { push @eqns, "n_$2 = n_$3 * $1" }
    while (/($decimal) (?:times )?as many (\w+) as (\w+)/g)                 { push @eqns, "n_$2 = n_$3 * $1" }
    while (/(\d+) more (\w+) than (\w+)/g)                                  { push @eqns, "n_$2 = n_$3 + $1" }
    while (/(\d+) less (\w+) than (\w+)/g)                                  { push @eqns, "n_$2 = n_$3 - $1" }
    while (/(\d+) less \$ (\d+) bill than \$ (\d+) bill/g)                  { push @eqns, "n_$2 = n_$3 - $1" }

    if (/same number (\w+) , (\w+) (?:, )?and (\w+)/) {
        push @eqns, "n_$1 = n_$2";
        push @eqns, "n_$2 = n_$3";
    }

    if (/(\d+) (?:\w+ )*consists/ or /(?<!\$ )(\d+) coin/ or /[^\$] (\d+) bill/) {
        $count = $1; push @vars, "count: $count"
    }

    if (/total (?:\w+ )*\$ ($decimal)/ or /valu(?:e|ing) \$ ($decimal)/ or /\$ ($decimal) ((bill|coin) )?in/) {
        $total = 100 * $1;
        push @vars, "total: $total";
    }

    if (/total (?:\w+ )*($decimal)/) {
        $total = $1;
        push @vars, "total: $total";
    }

    # Step 4: tally final total value, coin count

    # sum total, dot product of values and quantities
    my $dot_product = join(' + ', map {"n_$_ * v_$_"} uniq @types);
    push @eqns, "total = $dot_product" if $total and @types;

    # count of all coins, sum of counts of each coin type
    my $trace = join(' + ', map {"n_$_"} uniq @types);
    push @eqns, "count = $trace" if $count and @types;

    # Step 5: prepare batch file for external processing, run 'MAXIMA', output results

    printf "problem: %s\n", s/\n/ /gr;  # condensed problem statement

    my $maxima_vars = join("\$\n", uniq @vars);
    my $maxima_eqns = '['. join(', ', @eqns) . ']';
    my $maxima_find = '['. join(', ', map {"n_$_"} @types) . ']';

    if (@eqns and @vars) {
        my ($fh, $maxima_script) = tempfile(UNLINK => 1);
        open $fh, '>', $maxima_script or die "Couldn't open temporary file: $!\n";
        print $fh <<~"END";
            $maxima_vars\$
            solve($maxima_eqns, $maxima_find);
            END
        close $fh;

        open my $maxima_output, "/opt/local/bin/maxima -q -b $maxima_script |" or die "Couldn't open maxima: $!\n";
        while (<$maxima_output>) {
            print "solution: $1\n" if /\(\%o\d+\)\s+\[\[([^\]]+)\]\]/; # only display solution
        }
        close  $maxima_output;

    } else {
        print "Couldn't deduce enough information to formulate equations.\n"
    }
    print "\n";
}

__DATA__
If a person has three times as many quarters as dimes and the total amount of money is $5.95, find the number of quarters and dimes.

A pile of 18 coins consists of pennies and nickels. If the total amount of the coins is 38¢, find the number of pennies and nickels.

A small child has 6 more quarters than nickels. If the total amount of coins is $3.00, find the number of nickels and quarters the child has.

A childs bank contains 32 coins consisting of nickels and quarters. If the total amount of money is $3.80, find the number of nickels and quarters in the bank.

A person has twice as many dimes as she has pennies and three more nickels than pennies. If the total amount of the coins is $1.97, find the numbers of each type of coin the person has.

In a bank, there are three times as many quarters as half dollars and 6 more dimes than half dollars. If the total amount of the money in the bank is $4.65, find the number of each type of coin in the bank.

A clerk is given $75 in bills to put in a cash drawer at the start of a workday. There are twice as many $1 bills as $5 bills and one less $10 bill than $5 bills. How many of each type of bill are there?

A person has 8 coins consisting of quarters and dimes. If the total amount of this change is $1.25, how many of each kind of coin are there?

A person has 3 times as many dimes as he has nickels and 5 more pennies than nickels. If the total amount of these coins is $1.13, how many of each kind of coin does he have?

A person has 9 more dimes than nickels. If the total amount of money is $1.20, find the number of dimes the person has.

A person has 20 bills consisting of $1 bills and $2 bills. If the total amount of money the person has is $35, find the number of $2 bills the person has.

A bank contains 8 more pennies than nickels and 3 more dimes than nickels. If the total amount of money in the bank is $3.10, find the number of dimes in the bank.

The twenty-six coins in my pocket are all dollar coins and quarters, and they add up to seventeen dollars in value. How many of each coin are there?

A collection of 33 coins, consisting of nickels, dimes, and quarters, has a value of $3.30. If there are three times as many nickels as quarters, and one-half as many dimes as nickels, how many coins of each kind are there?

A wallet contains the same number of pennies, nickels, and dimes. The coins total $1.44. How many of each type of coin does the wallet contain?

Suppose Ken has 25 coins in nickels and dimes only and has a total of $1.65. How many of each coin does he have?

Terry has 2 more quarters than dimes and has a total of $6.80. The number of quarters and dimes is 38. How many quarters and dimes does Terry have?

In my wallet, I have one-dollar bills, five-dollar bills, and ten-dollar bills. The total amount in my wallet is $43. I have four times as many one-dollar bills as ten-dollar bills. All together, there are 13 bills in my wallet. How many of each bill do I have?

Marsha has three times as many one-dollar bills as she does five dollar bills. She has a total of $32. How many of each bill does she have?

A vending machine has $41.25 in it. There are 255 coins total and the machine only accepts nickels, dimes and quarters. There are twice as many dimes as nickels. How many of each coin are in the machine.

Michael had 27 coins in all, valuing $4.50. If he had only quarters and dimes, how many coins of each kind did he have?

Lucille had $13.25 in nickels and quarters. If she had 165 coins in all, how many of each type of coin did she have?

Ben has $45.25 in quarters and dimes. If he has 29 less quarters than dimes, how many of each type of coin does he have?

A person has 12 coins consisting of dimes and pennies. If the total amount of money is $0.30, how many of each coin are there?
