my ($major,$minor) = prompt("Dimensions? ").comb(/\d+/);
my @array = [ '@' xx $minor ] xx $major;
@array[ *.rand ][ *.rand ] = ' ';
.say for @array;
