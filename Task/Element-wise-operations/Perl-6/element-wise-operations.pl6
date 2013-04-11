my @a =
    [1,2,3],
    [4,5,6],
    [7,8,9];

sub msay(@x) {
    .perl.say for @x;
    say '';
}

msay @a «+» @a;
msay @a «-» @a;
msay @a «*» @a;
msay @a «/» @a;
msay @a «+» [1,2,3];
msay @a «-» [1,2,3];
msay @a «*» [1,2,3];
msay @a «/» [1,2,3];
msay @a «+» 2;
msay @a «-» 2;
msay @a «*» 2;
msay @a «/» 2;
