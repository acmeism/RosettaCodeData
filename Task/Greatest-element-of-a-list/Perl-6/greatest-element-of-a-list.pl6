say max 10, 4, 5, -2, 11;
say max <zero one two three four five six seven eight nine>;

# Even when the values and number of values aren't known until runtime
my @list = flat(0..9,'A'..'H').roll((^60).pick).rotor(4,:partial)».join.words;
say @list, ': ', max @list;
