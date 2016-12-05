use MONKEY-SEE-NO-EVAL;

my @digits;
my $amount = 4;

# Get $amount digits from the user,
# ask for more if they don't supply enough
while @digits.elems < $amount {
    @digits.append: (prompt "Enter {$amount - @digits} digits from 1 to 9, "
    ~ '(repeats allowed): ').comb(/<[1..9]>/);
}
# Throw away any extras
@digits = @digits[^$amount];

# Generate combinations of operators
my @ops = [X,] <+ - * /> xx 3;

# Enough sprintf formats to cover most precedence orderings
my @formats = (
    '%d %s %d %s %d %s %d',
    '(%d %s %d) %s %d %s %d',
    '(%d %s %d %s %d) %s %d',
    '((%d %s %d) %s %d) %s %d',
    '(%d %s %d) %s (%d %s %d)',
    '%d %s (%d %s %d %s %d)',
    '%d %s (%d %s (%d %s %d))',
);

# Brute force test the different permutations
for unique @digits.permutations -> @p {
    for @ops -> @o {
        for @formats -> $format {
            my $string = sprintf $format, flat roundrobin(|@p; |@o);
            my $result = EVAL($string);
            say "$string = 24" and last if $result and $result == 24;
        }
    }
}

# Only return unique sub-arrays
sub unique (@array) {
    my %h = map { $_.Str => $_ }, @array;
    %h.values;
}
