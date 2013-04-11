...
# property names and values
setprops
	'Who'	=> [ qw(baker cooper fletcher miller smith) ],
	'Level'	=> [ qw(one two three four five) ];

# constraints
pair qw(0 one);
pair qw(1 two);
pair qw(2 three);
pair qw(3 four);
pair qw(4 five);
pair qw(baker five -4 -3 -2 -1 1 2 3 4);
pair qw(cooper one -4 -3 -2 -1 1 2 3 4);
pair qw(fletcher one -4 -3 -2 -1 1 2 3 4);
pair qw(fletcher five -4 -3 -2 -1 1 2 3 4);
pair qw(miller cooper -1 -2 -3 -4);
pair qw(smith fletcher 4 3 2 -2 -3 -4);
pair qw(cooper fletcher 4 3 2 -2 -3 -4);

$solve->();
