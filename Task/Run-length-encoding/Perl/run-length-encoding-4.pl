use Data::Dump qw(dd);
dd my $str = "XXXXXABCDEFGHIoooooooooooooooooooooooooAAAAAA";
dd my $enc = encode($str);
dd decode($enc);
