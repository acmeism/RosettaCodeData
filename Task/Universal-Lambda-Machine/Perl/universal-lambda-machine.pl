#!/usr/bin/perl
sub bit2lam {
  my $bit = pop;
  sub { my $x0 = pop; sub { my $x1 = pop; $bit ? $x1 : $x0 } }
}
sub byte2lam {
  my ($bits,$n) = @_;
  $n == 0 ? sub { sub { pop } }                  # nil
          : sub { pop->(bit2lam(vec$bits,$n-1,1))->(byte2lam($bits,$n-1)) }
}
sub input {
  my $n = pop;                                   # input from n'th character onward
  if ($n >= @B) {
    my $c = getc;
    push @B, !defined($c) ? sub {sub { pop } }   # nil
             : sub { pop->($bytemode ? byte2lam($c,8) : bit2lam($c))->(input($n+1)) }
  }
  $B[$n];
}
sub lam2bit {
  pop->(sub{0})->(sub{1})->()              # force suspension
}
sub lam2byte {
  my ($lambits, $x) = @_;	           # 2nd argument is partial byte
  $lambits->(sub { my $lambit = pop; sub { my $tail = pop; sub { lam2byte($tail, 2*$x + lam2bit($lambit)) }
          }})->(chr $x)                    # end of byte
}
sub output {
  pop->(sub { my $c = pop; print($bytemode ? lam2byte($c,0) : lam2bit($c));
          sub { my $tail = pop; sub { output($tail) } } })->(0)    # end of output
}
sub getbit {
  $n ||= ($c = getc, $bytemode ? 8 : 1);
  vec $c,--$n,1;
}
sub program {
  if (getbit()) {             # variable
    my $i;
    $i++ while getbit();
    sub { $_[$i] }
  } elsif (getbit()) {        # application
    my $p=program();
    my $q=program();
    sub { my @env = @_; $p->(@env)->(sub { $q->(@env)->(pop) }) } # suspend argument
  } else {
    my $p = program();
    sub { my @env = @_; sub { $p->(pop,@env) } }  # extend environment with one more argument
  }
}
$bytemode = !pop;                    # any argument sets bitmode instead
$| = 1;                              # non zero value sets autoflush
$prog = program()->();
output $prog->(input(0))             # run program with empty env on input
