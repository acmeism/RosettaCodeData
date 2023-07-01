#!/usr/bin/env perl

use strict;
use warnings;
no warnings 'once';


#----- Definition of the language to be lexed -----#

my @tokens = (
    # Name            | Format               | Value       #
    # --------------  |----------------------|-------------#
    ['Op_multiply'    , '*'                  ,             ],
    ['Op_divide'      , '/'                  ,             ],
    ['Op_mod'         , '%'                  ,             ],
    ['Op_add'         , '+'                  ,             ],
    ['Op_subtract'    , '-'                  ,             ],
    ['Op_lessequal'   , '<='                 ,             ],
    ['Op_less'        , '<'                  ,             ],
    ['Op_greaterequal', '>='                 ,             ],
    ['Op_greater'     , '>'                  ,             ],
    ['Op_equal'       , '=='                 ,             ],
    ['Op_assign'      , '='                  ,             ],
    ['Op_not'         , '!'                  ,             ],
    ['Op_notequal'    , '!='                 ,             ],
    ['Op_and'         , '&&'                 ,             ],
    ['Op_or'          , '||'                 ,             ],
    ['Keyword_else'   , qr/else\b/           ,             ],
    ['Keyword_if'     , qr/if\b/             ,             ],
    ['Keyword_while'  , qr/while\b/          ,             ],
    ['Keyword_print'  , qr/print\b/          ,             ],
    ['Keyword_putc'   , qr/putc\b/           ,             ],

    ['LeftParen'      , '('                  ,             ],
    ['RightParen'     , ')'                  ,             ],
    ['LeftBrace'      , '{'                  ,             ],
    ['RightBrace'     , '}'                  ,             ],
    ['Semicolon'      , ';'                  ,             ],
    ['Comma'          , ','                  ,             ],

    ['Identifier'     , qr/[_a-z][_a-z0-9]*/i, \&raw       ],
    ['Integer'        , qr/[0-9]+\b/         , \&raw       ],
    ['Integer'        , qr/'([^']*)(')?/     , \&char_val  ],
    ['String'         , qr/"([^"]*)(")?/     , \&string_raw],

    ['End_of_input'   , qr/$/                ,             ],
);

my $comment = qr/\/\* .+? (?: \*\/ | $ (?{die "End-of-file in comment\n"}) )/xs;
my $whitespace = qr/(?: \s | $comment)*/x;
my $unrecognized = qr/\w+ | ./x;

#| Returns the value of a matched char literal, or dies if it is invalid
sub char_val {
    my $str = string_val();
    die "Multiple characters\n" if length $str > 1;
    die "No character\n"        if length $str == 0;
    ord $str;
}

#| Returns the value of a matched string literal, or dies if it is invalid
sub string_val {
    my ($str, $end) = ($1, $2);
    die "End-of-file\n" if not defined $end;
    die "End-of-line\n" if $str =~ /\n/;
    $str =~ s/\\(.)/
          $1 eq 'n'  ? "\n"
        : $1 eq '\\' ? $1
        : $1 eq $end ? $1
        : die "Unknown escape sequence \\$1\n"
    /rge;
}

#| Returns the source string of a matched literal
sub raw { $& }

#| Returns the source string of a matched string literal, or dies if invalid
sub string_raw {
    string_val(); # Just for the error handling side-effects
    $&;
}


#----- Lexer "engine" -----#

# Construct the scanner regex:

my $tokens =
    join "|",
    map {
        my $format = $tokens[$_][1];
        "\n".(ref $format ? $format : quotemeta $format)." (*MARK:$_) ";
    } 0..$#tokens;

my $regex = qr/
    \G (?| $whitespace  \K (?| $tokens )
         | $whitespace? \K ($unrecognized) (*MARK:!) )
/x;


# Run the lexer:

my $input = do { local $/ = undef; <STDIN> };
my $pos = 0;
my $linecol = linecol_accumulator();

while ($input =~ /$regex/g) {
    # Get the line and column number
    my ($line, $col) = $linecol->(substr $input, $pos, $-[0] - $pos);
    $pos = $-[0];

    # Get the token type that was identified by the scanner regex
    my $type = $main::REGMARK;
    die "Unrecognized token $1 at line $line, col $col\n" if $type eq '!';
    my ($name, $evaluator) = @{$tokens[$type]}[0, 2];

    # Get the token value
    my $value;
    if ($evaluator) {
        eval { $value = $evaluator->() };
        if ($@) { chomp $@; die "$@ in $name at line $line, col $col\n" }
    }

    # Print the output line
    print "$line\t$col\t$name".($value ? "\t$value" : '')."\n";
}

#| Returns a closure, which can be fed a string one piece at a time and gives
#| back the cumulative line and column number each time
sub linecol_accumulator {
    my ($line, $col) = (1, 1);
    sub {
        my $str = shift;
        my @lines = split "\n", $str, -1;
        my ($l, $c) = @lines ? (@lines - 1, length $lines[-1]) : (0, 0);
        if ($l) { $line += $l;  $col = 1 + $c }
        else    { $col += $c }
        ($line, $col)
    }
}
