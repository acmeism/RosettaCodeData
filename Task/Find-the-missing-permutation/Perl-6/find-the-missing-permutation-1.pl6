# The givens from Rosetta Code:
my @givens = <ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB CDBA CBAD ABDC ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB>;

# Get all the unique permutations of ABCD
my @letters = <A B C D>;
my @perms = (@letters X~ @letters X~ @letters X~ @letters).grep: {
        .chars == .split('').uniq.elems
};
# Print out the missing value:
.say for grep none(@givens), @perms;
