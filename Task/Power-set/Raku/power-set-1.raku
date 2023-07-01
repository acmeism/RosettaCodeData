sub powerset(Set $s) { $s.combinations.map(*.Set).Set }
say powerset set <a b c d>;
