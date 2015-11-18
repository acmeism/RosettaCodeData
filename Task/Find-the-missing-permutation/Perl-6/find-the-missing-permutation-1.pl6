my @givens = <ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB CDBA
                CBAD ABDC ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB>;

my @perms = <A B C D>.permutations.map: *.join;

.say when none(@givens) for @perms;
