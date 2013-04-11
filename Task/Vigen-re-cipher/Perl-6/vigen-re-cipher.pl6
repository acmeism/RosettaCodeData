sub s2v ($s) { $s.uc.comb(/ <[ A..Z ]> /)».ord »-» 65 }
sub v2s (@v) { (@v »%» 26 »+» 65)».chr.join }

sub blacken ($red, $key) { v2s s2v($red) »+» s2v($key) }
sub redden  ($blk, $key) { v2s s2v($blk) »-» s2v($key) }

my $red = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!";
my $key = "Vigenere Cipher!!!";

say $red;
say my $black = blacken($red, $key);
say redden($black, $key);
