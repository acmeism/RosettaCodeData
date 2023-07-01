my $monad = <42>;
say 'Is $monad an Int?: ', $monad ~~ Int;
say 'Is $monad a  Str?: ', $monad ~~ Str;
say 'Wait, what? What exactly is $monad?: ', $monad.^name;
