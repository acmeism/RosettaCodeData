my $sum = 100;
my $N   = 10;
my @ops = ['-', ''], |( [' + ', ' - ', ''] xx 8 );
my @str = [X~] map { .Slip }, ( @ops Z 1..9 );
my %sol = @str.classify: *.subst( ' - ', ' -', :g )\
                          .subst( ' + ',  ' ', :g ).words.sum;

my %count.push: %sol.map({ .value.elems => .key });

my $max-solutions    = %count.max( + *.key );
my $first-unsolvable = first { %sol{$_} :!exists }, 1..*;
sub n-largest-sums (Int $n) { %sol.sort(-*.key)[^$n].fmt: "%8s => %s\n" }

given %sol{$sum}:p {
    say "{.value.elems} solutions for sum {.key}:";
    say "    $_" for .value.list;
}

.say for :$max-solutions, :$first-unsolvable, "$N largest sums:", n-largest-sums($N);
