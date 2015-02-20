grammar S-Exp {
  rule TOP    {^ <s-list> $};

  token s-list { '(' ~ ')' [ <in_list>+ % [\s+] | '' ] }
  token in_list { <s-token> | <s-list> }

  proto token s-token {*}
  token s-token:sym<Num>    {\d*\.?\d+}
  token s-token:sym<String> {'"' ['\"' |<-[\\"]>]*? '"'} #'
  token s-token:sym<Atom>   {<-[()\s]>+}

}

# The Actions class, for each syntactic rule there is a method
# that stores some data in the abstract syntax tree with make
class S-Exp::ACTIONS {
  method TOP ($/) {make $<s-list>.ast}
  method s-list ($/) {make [$<in_list>».ast]}
  method in_list ($/) {make $/.values[0].ast}

  method s-token:sym<Num> ($/){make +$/}
  method s-token:sym<String> ($/){make ~$/.substr(1,*-1)}
  method s-token:sym<Atom> ($/){make ~$/}
}

multi s-exp_writer (Positional $ary) {'(' ~ $ary.map(&s-exp_writer).join(' ') ~ ')'}
multi s-exp_writer (Numeric    $num) {~$num}
multi s-exp_writer (Str        $str) {
  return $str unless $str ~~ /<[(")]>|\s/;
  return '()' if $str eq '()';
  '"' ~ $str.subst('"', '\"' ) ~ '"';
}


my $s-exp = '((data "quoted data" 123 4.5)
 (data (!@# (4.5) "(more" "data)")))';

my $actions = S-Exp::ACTIONS.new();
my $perl_array = (S-Exp.parse($s-exp, :$actions)).ast;

say "the expression:\n$s-exp\n";
say "the perl6-expression:\n{$perl_array.perl}\n";
say "and back:\n{s-exp_writer($perl_array)}";
