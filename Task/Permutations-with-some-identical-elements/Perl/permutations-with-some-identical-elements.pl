use ntheory qw<formultiperm>;

formultiperm { print join('',@_) . ' ' } [<1 1 2>];           print "\n\n";
formultiperm { print join('',@_) . ' ' } [<1 1 2 2 2 3>];     print "\n\n";
formultiperm { print join('',@_) . ' ' } [split //,'AABBBC']; print "\n";
