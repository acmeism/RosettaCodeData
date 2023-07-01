 my %prec =
   '^' => 4,
   '*' => 3,
   '/' => 3,
   '+' => 2,
   '-' => 2,
   '(' => 1;

my %assoc =
   '^' => 'right',
   '*' => 'left',
   '/' => 'left',
   '+' => 'left',
   '-' => 'left';

sub shunting-yard ($prog) {
   my @inp = $prog.words;
   my @ops;
   my @res;

   sub report($op) { printf "%25s    %-7s %10s %s\n", ~@res, ~@ops, $op, ~@inp }
   sub shift($t)  { report( "shift $t"); @ops.push: $t }
   sub reduce($t) { report("reduce $t"); @res.push: $t }

   while @inp {
     given @inp.shift {
       when /\d/ { reduce $_ };
       when '(' { shift $_ }
       when ')' { while @ops and (my $x = @ops.pop and $x ne '(') { reduce $x } }
       default {
         my $newprec = %prec{$_};
           while @ops {
              my $oldprec = %prec{@ops[*-1]};
              last if $newprec > $oldprec;
              last if $newprec == $oldprec and %assoc{$_} eq 'right';
              reduce @ops.pop;
           }
           shift $_;
       }
     }
   }
   reduce @ops.pop while @ops;
   @res;
}

say shunting-yard '3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3';
