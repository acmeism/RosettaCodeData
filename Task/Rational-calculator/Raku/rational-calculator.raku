say 'Enter an empty line to quit';

while my $line = prompt('>') {
     state $this;
     $line.=subst: '@', $this;
     $this = $line.EVAL.FatRat;
     my ($non-rep, $repeating) = $this.base-repeating: 10;
     say $repeating ?? sprintf( '=%s(%s)', $non-rep, $repeating)  !! "=$non-rep"
}
