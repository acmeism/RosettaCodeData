open(my $fh, '<', 'foobar.txt') or die "$!";
while (readline $fh)
{ ... }

while (my $line = readline $fh)
{ ... }
close $fh;
