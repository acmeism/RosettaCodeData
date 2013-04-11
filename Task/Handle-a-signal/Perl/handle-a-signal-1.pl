my $start = time;

$SIG{INT} = sub
   {print 'Ran for ', time - $start, " seconds.\n";
    exit;};

for (my $n = 0 ;; select(undef, undef, undef, .5))
   {print ++$n, "\n";}
