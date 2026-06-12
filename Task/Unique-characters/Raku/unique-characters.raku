my @list = <133252abcdeeffd a6789798st yxcdfgxcyz>;

for @list, (@list, 'AАΑSäaoö٥🤔👨‍👩‍👧‍👧') {
    say "$_\nSemi-bogus \"Unicode natural sort\" order: ",
    .map( *.comb ).Bag.grep( *.value == 1 )».key.sort( { .unival, .NFKD[0], .fc } ).join,
    "\n        (DUCET) Unicode collation order: ",
    .map( *.comb ).Bag.grep( *.value == 1 )».key.collate.join, "\n";
}
