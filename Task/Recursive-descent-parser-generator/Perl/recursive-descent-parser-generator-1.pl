#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Recursive_descent_parser_generator
use warnings;
use Path::Tiny;

my $h = qr/\G\s*/;
my $identifier = qr/$h([a-z]\w*)\b/i;
my $literal = qr/$h(['"])(.+?)\1/s;
my (%rules, %called, $usercode, %patches);
my $filename = './generatedparser.pl';

sub node { bless [ @_[1..$#_] ], $_[0] }
sub error { die "ERROR: ", s/\G\s*\K/<**ERROR @_**>/r, "\n" }
sub want { /$h\Q$_[1]\E/gc ? shift : error "missing '$_[1]' " }
sub addin { node $_[0] => ref $_[1] eq $_[0] ? @{$_[1]} : $_[1], pop }

local $_ = do { local $/; @ARGV ? <> : <DATA> }; # the EBNF
$usercode = s/^(#usercode.*)//ms ? $1 : "# no usercode included\n";;
$patches{PATCHUSER} = $usercode . "#end usercode\n"; # grammar support code
s/^\h*#.*\n//gm; # remove comment lines
$patches{PATCHGRAMMAR} = s/^(?:\h*\n)+//r =~ s/\n(?:\h*\n)+\z//r;
while( /$identifier\s*=/gc )              # the start of a rule
  {
  my $name = $1;
  $rules{startsymbol} //= node RULE => $name;
  my $tree = expr(0);
  $rules{$name} = $rules{$name} ? addin ALT => $rules{$name}, $tree : $tree;
  /$h[.;]/gc or error 'missing rule terminator, needs . or ;';
  }
/\G\s*\z/ or error "incomplete parse at ", substr $_, pos($_) // 0;
%rules or error "no rules found ";
delete @called{keys %rules};
%called and die "\nERROR: undefined rule(s) <@{[ keys %called]}>\n";

sub expr                     # precedence climbing parser for grammer rules
  {
  my $tree =
    /$h(NAME)\b/gc    ? node $1 :                       # internal name matcher
    /$identifier/gc   ? do { $called{$1}++; node RULE => $1 } :
    /$literal/gc      ? node LIT => $2 :
    /$h<(\w+)>/gc     ? node ACTION => $1 :
    /$h\[/gc          ? node OPTION => want expr(0), ']' :
    /$h\{/gc          ? node REPEAT => want expr(0), '}' :
    /$h\(/gc          ?                want expr(0), ')' :
    error 'Invalid expression';
  $tree =
    /\G\s+/gc                            ? $tree :
    $_[0] <= 1 && /\G(?=[[<{('"a-z])/gci ? addin SEQ => $tree, expr(2) :
    $_[0] <= 0 && /\G\|/gc               ? addin ALT => $tree, expr(1) :
    return $tree while 1;
  }

my $perlcode = "# generated code (put in Rule:: package)\n";
for my $rule ( sort keys %rules )
  {
  my $body = $rules{$rule}->code;
  $perlcode .= "\nsub Rule::$rule\n\t{\n\t$body\n\t}\n";
  }
$perlcode =~ s/^(?:\h*\n)+(?=\h*\})//gm;
$perlcode .= "\n# preceding code was generated for rules\n";
$patches{PATCHGENERATED} = $perlcode;
sub ALT::code
  {
  my $all = join " or\n\t", map $_->code, @{ $_[0] };
  "( # alt\n\t$all )"
  }
sub SEQ::code
  {
  my $all = join " and\n\t", map $_->code, @{ $_[0] };
  "( # seq\n\t$all )"
  }
sub REPEAT::code { "do { # repeat\n\t1 while @{[ $_[0][0]->code ]} ; 1 }" }
sub OPTION::code { "( # option\n\t@{[ $_[0][0]->code ]} or 1 )" }
sub RULE::code { "Rule::$_[0][0]()" }
sub ACTION::code { "( $_[0][0]() || 1 )" }
sub NAME::code { "( /\\G\$whitespace(\\w+)/gc and push \@stack, \$1 )" }
sub LIT::code { "( /\\G\$whitespace(\Q$_[0][0]\E)/gc and push \@stack, \$1 )" }

$_ = <<'END'; ##################################### template for generated code
#!/usr/bin/perl
use strict; # https://rosettacode.org/wiki/Recursive_descent_parser_generator
use warnings; # WARNING: this code is generated

my @stack;
my $whitespace = qr/\s*/;

my $grammar = <<'GRAMMAR'; # make grammar rules available to usercode
PATCHGRAMMAR
GRAMMAR

PATCHUSER
PATCHGENERATED
local $_ = shift // '(one + two) * three - four * five';
eval { begin() };                           # eval because it is optional
Rule::startsymbol();
eval { end() };                             # eval because it is optional
/\G\s*\z/ or die "ERROR: incomplete parse\n";
END

s/(PATCH\w+)/$patches{$1}/g; # insert grammar variable stuff
path( $filename )->spew( $_ );
chmod 0555, $filename; # readonly, executable
exec 'perl', $filename, @ARGV or die "exec failed $!";

__DATA__

expr = term { plus term <gen3addr> } .
term = factor { times factor <gen3addr> } .
factor = primary [ '^' factor <gen3addr> ] .
primary = '(' expr ')' <removeparens> | NAME .
plus = "+" | "-" .
times = "*" | "/" .

#usercode -- separator for included code for actions

my $temp = '0000';

sub begin { print "parsing: $_\n\n" }

sub gen3addr
  {
  @stack >= 3 or die "not enough on stack";
  my @three = splice @stack, -3, 3, my $t = '_' . ++$temp;
  print "$t = @three\n";
  }

sub removeparens
  {
  @stack >= 3 or die "not enough on stack";
  splice @stack, -3, 3, $stack[-2];
  }
