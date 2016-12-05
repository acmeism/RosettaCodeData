enum Trit <Foo Moo Too>;

sub prefix:<¬> (Trit $a) { Trit(1-($a-1)) }

sub infix:<∧> (Trit $a, Trit $b) is equiv(&infix:<*>) { $a min $b }
sub infix:<∨> (Trit $a, Trit $b) is equiv(&infix:<+>) { $a max $b }

sub infix:<⇒> (Trit $a, Trit $b) is equiv(&infix:<..>) { ¬$a max $b }
sub infix:<≡> (Trit $a, Trit $b) is equiv(&infix:<eq>) { Trit(1 + ($a-1) * ($b-1)) }
