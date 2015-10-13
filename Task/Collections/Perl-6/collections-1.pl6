# Array
my @array = 1,2,3;
@array.push: 4,5,6;

# Hash
my %hash = 'a' => 1, 'b' => 2;
%hash<c d> = 3,4;
%hash.push: 'e' => 5, 'f' => 6;

# SetHash
my $s = SetHash.new: <a b c>;
$s ∪= <d e f>;

# BagHash
my $b = BagHash.new: <b a k l a v a>;
$b ⊎= <a b c>;
