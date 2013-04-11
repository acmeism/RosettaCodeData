my ($major,$minor) = prompt("Dimensions? ").comb(/\d+/);
my @array := [ for ^$major { [ for ^$minor {'@'} ] } ];
@array[ pick 1, ^$major ][ pick 1, ^$minor ] = ' ';
.say for @array;
