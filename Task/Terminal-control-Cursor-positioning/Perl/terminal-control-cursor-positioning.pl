use Term::Cap;

my $t = Term::Cap->Tgetent;
print $t->Tgoto("cm", 2, 5); # 0-based
print "Hello";
