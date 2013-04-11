my $stty = qx[stty -a];
my $lines = $stty.match(/ 'rows '    <( \d+/);
my $cols  = $stty.match(/ 'columns ' <( \d+/);
say "$lines $cols";
