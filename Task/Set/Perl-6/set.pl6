use Test;

my $a = set <a b c>;
my $b = set <b c d>;
my $c = set <a b c d e>;

ok 'c' ∈ $a, "c is an element in set A";
nok 'd' ∈ $a, "d is not an element in set A";

is-deeply $a ∪ $b, set(<a b c d>), "union; a set of all elements either in set A or in set B";
is-deeply $a ∩ $b, set(<b c>), "intersection; a set of all elements in both set A and set B";
is $a (-) $b, set(<a>), "difference; a set of all elements in set A, except those in set B";

ok $a ⊆ $c, "subset; true if every element in set A is also in set B";
nok $c ⊆ $a, "subset; false if every element in set A is not also in set B";
ok $a ⊂ $c, "strict subset; true if every element in set A is also in set B";
nok $a ⊂ $a, "strict subset; false for equal sets";
ok $a === set(<a b c>), "equality; true if every element of set A is in set B and vice-versa";
nok $a === $b, "equality; false for differing sets";
