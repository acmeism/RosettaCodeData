my $lp = open '/dev/lp0', :w;
$lp.say: 'Hello World!';
$lp.close;
