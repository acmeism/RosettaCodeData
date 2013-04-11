my @look-and-say := (
    '1',
    *.comb(/(.)$0*/).map({ .chars ~ .substr(0,1) }).join
    ...
    *
);

.say for @look-and-say[^10];
