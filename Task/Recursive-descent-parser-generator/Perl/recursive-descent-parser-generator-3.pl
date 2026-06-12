# test arith expr

expr = term { '+' term <fadd> | '-' term <fsub> } .
term = factor { '*' factor <fmul> | '/' factor <fdiv> } .
factor = '(' expr ')' <noparen> | NAME .

#usercode

sub noparen { splice @stack, -3, 3, $stack[-2]; }
sub fadd { splice @stack, -3, 3, $stack[-3] + $stack[-1] }
sub fsub { splice @stack, -3, 3, $stack[-3] - $stack[-1] }
sub fmul { splice @stack, -3, 3, $stack[-3] * $stack[-1] }
sub fdiv { splice @stack, -3, 3, $stack[-3] / $stack[-1] }
sub begin { print "expr   = $_\n" }
sub end { print "answer = @{[pop @stack]}\n" }
