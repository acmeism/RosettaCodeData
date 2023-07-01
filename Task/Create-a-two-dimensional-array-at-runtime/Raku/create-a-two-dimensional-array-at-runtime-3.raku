my ($major,$minor) = +«prompt("Dimensions? ").comb(/\d+/);
my Int @array[$major;$minor] = (7 xx $minor ) xx $major;
@array[$major div 2;$minor div 2] = 42;
say @array;
