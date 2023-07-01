grammar tiny_C {
    rule TOP { ^ <.whitespace>? <tokens> + % <.whitespace> <.whitespace> <eoi> }

    rule whitespace { [ <comment> + % <ws> | <ws> ] }

    token comment    { '/*' ~ '*/' .*? }

    token tokens {
        [
        | <operator>   { make $/<operator>.ast   }
        | <keyword>    { make $/<keyword>.ast    }
        | <symbol>     { make $/<symbol>.ast     }
        | <identifier> { make $/<identifier>.ast }
        | <integer>    { make $/<integer>.ast    }
        | <char>       { make $/<char>.ast       }
        | <string>     { make $/<string>.ast     }
        | <error>
        ]
    }

    proto token operator    {*}
    token operator:sym<*>   { '*'               { make 'Op_multiply'    } }
    token operator:sym</>   { '/'<!before '*'>  { make 'Op_divide'      } }
    token operator:sym<%>   { '%'               { make 'Op_mod'         } }
    token operator:sym<+>   { '+'               { make 'Op_add'         } }
    token operator:sym<->   { '-'               { make 'Op_subtract'    } }
    token operator:sym('<='){ '<='              { make 'Op_lessequal'   } }
    token operator:sym('<') { '<'               { make 'Op_less'        } }
    token operator:sym('>='){ '>='              { make 'Op_greaterequal'} }
    token operator:sym('>') { '>'               { make 'Op_greater'     } }
    token operator:sym<==>  { '=='              { make 'Op_equal'       } }
    token operator:sym<!=>  { '!='              { make 'Op_notequal'    } }
    token operator:sym<!>   { '!'               { make 'Op_not'         } }
    token operator:sym<=>   { '='               { make 'Op_assign'      } }
    token operator:sym<&&>  { '&&'              { make 'Op_and'         } }
    token operator:sym<||>  { '||'              { make 'Op_or'          } }

    proto token keyword      {*}
    token keyword:sym<if>    { 'if'    { make 'Keyword_if'    } }
    token keyword:sym<else>  { 'else'  { make 'Keyword_else'  } }
    token keyword:sym<putc>  { 'putc'  { make 'Keyword_putc'  } }
    token keyword:sym<while> { 'while' { make 'Keyword_while' } }
    token keyword:sym<print> { 'print' { make 'Keyword_print' } }

    proto token symbol  {*}
    token symbol:sym<(> { '(' { make 'LeftParen'  } }
    token symbol:sym<)> { ')' { make 'RightParen' } }
    token symbol:sym<{> { '{' { make 'LeftBrace'  } }
    token symbol:sym<}> { '}' { make 'RightBrace' } }
    token symbol:sym<;> { ';' { make 'Semicolon'   } }
    token symbol:sym<,> { ',' { make 'Comma'       } }

    token identifier { <[_A..Za..z]><[_A..Za..z0..9]>* { make 'Identifier ' ~ $/ } }
    token integer    { <[0..9]>+                       { make 'Integer '    ~ $/ } }

    token char {
        '\'' [<-[']> | '\n' | '\\\\'] '\''
        { make 'Char_Literal ' ~ $/.subst("\\n", "\n").substr(1, *-1).ord }
    }

    token string {
        '"' <-["\n]>* '"' #'
        {
            make 'String ' ~ $/;
            note 'Error: Unknown escape sequence.' and exit if (~$/ ~~ m:r/ <!after <[\\]>>[\\<-[n\\]>]<!before <[\\]>> /);
        }
    }

    token eoi { $ { make 'End_of_input' } }

    token error {
        | '\'''\''                   { note 'Error: Empty character constant.' and exit }
        | '\'' <-[']> ** {2..*} '\'' { note 'Error: Multi-character constant.' and exit }
        | '/*' <-[*]>* $             { note 'Error: End-of-file in comment.'   and exit }
        | '"' <-["]>* $              { note 'Error: End-of-file in string.'    and exit }
        | '"' <-["]>*? \n            { note 'Error: End of line in string.'    and exit } #'
    }
}

sub parse_it ( $c_code ) {
    my $l;
    my @pos = gather for $c_code.lines>>.chars.kv -> $line, $v {
        take [ $line + 1, $_ ] for 1 .. ($v+1); # v+1 for newline
        $l = $line+2;
    }
    @pos.push: [ $l, 1 ]; # capture eoi

    for flat $c_code<tokens>.list, $c_code<eoi> -> $m {
        say join "\t", @pos[$m.from].fmt('%3d'), $m.ast;
    }
}

my $tokenizer = tiny_C.parse(@*ARGS[0].IO.slurp);
parse_it( $tokenizer );
