my @a = 1,2,3;
my @op = &infix:<+>, &infix:<->, &infix:<*>;
for flat @a Z @op -> $v, &op { say 42.&op($v) }
