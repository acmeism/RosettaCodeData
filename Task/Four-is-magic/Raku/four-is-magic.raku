use Lingua::EN::Numbers; # Version 2.4.0 or higher

sub card ($n) { cardinal($n).subst(/','/, '', :g) }

sub magic (Int $int is copy) {
    my $string;
    loop {
       $string ~= "{ card($int) } is ";
       if $int = ($int == 4) ?? 0 !! card($int).chars {
           $string ~= "{ card($int) }, "
       } else {
           $string ~= "magic.\n";
           last
       }
   }
   $string.tc
}

.&magic.say for 0, 4, 6, 11, 13, 75, 337, -164, 9876543209, 2**256;
