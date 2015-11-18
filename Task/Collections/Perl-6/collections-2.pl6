# List
my @list := 1,2,3;
my @newlist := |@list, 4,5,6; # |@list will slip @list into the surrounding list instead of creating a list of lists

# Set
my $set = set <a b c>;
my $newset = $set ∪ <d e f>;

# Bag
my $bag = bag <b a k l a v a>;
my $newbag = $bag ⊎ <b e e f>;
