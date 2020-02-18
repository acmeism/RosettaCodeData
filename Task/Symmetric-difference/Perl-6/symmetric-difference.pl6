my \A = set <John Serena Bob Mary Serena>;
my \B = set <Jim Mary John Jim Bob>;

say  A ∖ B; # Set subtraction
say  B ∖ A; # Set subtraction
say (A ∪ B) ∖ (A ∩ B);  # Symmetric difference, via basic set operations
say  A ⊖ B;             # Symmetric difference, via dedicated operator
