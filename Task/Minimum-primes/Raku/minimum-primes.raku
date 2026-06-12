say ([Zmax] <5 45 23 21 67>, <43 22 78 46 38>, <9 98 12 54 53>)».&next-prime[^5];

sub next-prime { ($^m..*).first: &is-prime }
