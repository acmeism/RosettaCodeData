enum Trit <Foo Moo Too>;

sub prefix:<¬> (Trit $a) { Trit(1-($a-1)) }

sub infix:<∧> is equiv(&infix:<*>) (Trit $a, Trit $b) { $a min $b }
sub infix:<∨> is equiv(&infix:<+>) (Trit $a, Trit $b) { $a max $b }

sub infix:<⇒> is equiv(&infix:<..>) (Trit $a, Trit $b) { ¬$a max $b }
sub infix:<≡> is equiv(&infix:<eq>) (Trit $a, Trit $b) { Trit(1 + ($a-1) * ($b-1)) }
