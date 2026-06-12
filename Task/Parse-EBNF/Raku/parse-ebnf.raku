# A Raku grammar to parse EBNF
grammar EBNF {
    rule         TOP { ^ <title>? '{' [ <production> ]+ '}' <comment>? $ }
    rule  production { <name> '=' <expression> <[.;]> }
    rule  expression { <term> +% "|" }
    rule        term { <factor>+ }
    rule      factor { <group> | <repeat> | <optional> | <identifier> | <literal> }
    rule       group { '(' <expression> ')' }
    rule      repeat { '{' <expression> '}' }
    rule    optional { '[' <expression> ']' }
    token identifier { <-[\|\(\)\{\}\[\]\.\;\"\'\s]>+ } #"
    token    literal { ["'" <-[']>+ "'" | '"' <-["]>+ '"'] } #"
    token      title { <literal> }
    token    comment { <literal> }
    token       name { <identifier>  <?before \h* '='> }
}

class EBNF::Actions {
    method        TOP($/) {
                            say "Syntax Tree:\n", $/; # Dump the syntax tree to STDOUT
                            make 'grammar ' ~
                              ($<title> ?? $<title>.subst(/\W/, '', :g) !! 'unnamed') ~
                              " \{\n rule TOP \{^[<" ~ $/<production>[0]<name> ~
                              ">]+\$\}\n " ~ $<production>>>.ast ~ "\}"
                          }
   method production($/) {
                            make 'token ' ~ $<name> ~ ' {' ~
                              $<expression>.ast ~ "}\n"
                          }
   method expression($/) { make join '|', $<term>>>.ast }
   method       term($/) { make join '\h*', $<factor>>>.ast }
   method     factor($/) {
                            make $<literal>  ?? $<literal> !!
                              $<group>    ?? '[' ~ $<group>.ast    ~ ']'  !!
                              $<repeat>   ?? '[' ~ $<repeat>.ast   ~ '\\s*]*' !!
                              $<optional> ?? '[' ~ $<optional>.ast ~ ']?' !!
                              '<' ~ $<identifier> ~ '>'
                          }
   method     repeat($/) { make $<expression>.ast }
   method   optional($/) { make $<expression>.ast }
   method      group($/) { make $<expression>.ast }
}

# An array of test cases
my @tests = (
    {
        ebnf =>
            q<"a" {
                a = "a1" ( "a2" | "a3" ) { "a4" } [ "a5" ] "a6" ;
            } "z">
        ,
        teststrings => [
            'a1a3a4a4a5a6',
            'a1 a2a6',
            'a1 a3 a4 a6',
            'a1 a4 a5 a6',
            'a1 a2 a4 a4 a5 a6',
            'a1 a2 a4 a5 a5 a6',
            'a1 a2 a4 a5 a6 a7',
            'your ad here'
        ]
    },
    {
        ebnf =>
            q<{
                expr = term { plus term } .
                term = factor { times factor } .
                factor = number | '(' expr ')' .

                plus = "+" | "-" .
                times = "*" | "/" .

                number = digit { digit } .
                digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" .
            }>
        ,
        teststrings => [
            '2',
            '2*3 + 4/23 - 7',
            '(3 + 4) * 6-2+(4*(4))',
            '-2',
            '3 +',
            '(4 + 3'
        ]
    },
    {
        ebnf => q<a = "1";>,
        teststrings => ['foobar']
    },
    {
        ebnf => q<{ a = "1" ;>,
        teststrings => ['foobar']
    },
    {
        ebnf => q<{ hello world = "1"; }>,
        teststrings => ['foobar']
    },
    {
        ebnf => q<{ foo = bar . }>,
        teststrings => ['foobar']
    }
);

# Test the parser.
my $i = 1;
for @tests -> $test {
    unless EBNF.parse($test<ebnf>) {
         say "Parsing EBNF grammar:\n";
         say "{$test<ebnf>.subst(/^^\h*/,'',:g)}\n";
         say "Invalid syntax. Can not be parsed.\n";
         say '*' x 79;
         next;
    }
    my $p = EBNF.parse($test<ebnf>, :actions(EBNF::Actions));
    my $grammar = $p.ast;
    $grammar ~~ m/^'grammar '(\w+)/;
    my $title = $0;
    my $fn = 'EBNFtest'~$i++;
    my $fh = open($fn, :w) orelse .die;
    $fh.say( "\{\n", $grammar );
    $fh.say( qq|say "Parsing EBNF grammar '$title':\\n";| );
    $fh.say( qq|say q<{$test<ebnf>.subst(/^^\h*/,'',:g)}>;| );
    $fh.say(  q|say "\nValid syntax.\n\nTesting:\n";| );
    $fh.say(  q|CATCH { default { say " - $_" } };| );
    my $len = max $test<teststrings>.flat>>.chars;
    for $test<teststrings>.flat -> $s {
        $fh.say( qq|printf "%{$len}s", '{$s}';| ~
                 qq|printf " - %s\\n", {$title}.parse('{$s}')| ~
                 qq| ?? 'valid.' !! 'NOT valid.';|
               );
    }
    $fh.say( qq| "\\n"} |);
    $fh.close;
    say qqx/raku $fn/;
    say '*' x 79, "\n";
    unlink $fn;
}
