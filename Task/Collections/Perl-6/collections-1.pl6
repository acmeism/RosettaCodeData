# Array
my @array = 1,2,3;
@array.push: 4,5,6;

# Hash
my %hash = a => 1, b => 2;
%hash<c d> = 3,4;
%hash.push: e => 5, f => 6;

# KeySet
my $s = KeySet.new: <a b c>;
$s ∪= <d e f>;

# KeyBag
my $b = KeyBag.new: <b a k l a v a>;
$b.push: <d e f>;
