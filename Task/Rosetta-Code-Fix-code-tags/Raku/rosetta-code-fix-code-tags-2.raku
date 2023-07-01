use v6;

constant @langs = < abap actionscript actionscript3 ada  … >;

slurp().subst(
    rx:r{
        | '<' <( $<need-add-space>=<?> )> @langs '>'
        | '</' <( @langs )> '>'
        | '<' '/'? <( code )> [<.ws> @langs]? '>'
    },
    'lang' ~ " " x *<need-add-space>.so,
    :g,
).print
