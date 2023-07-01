USING: inverse qw sequences ;

: (quibble) ( seq -- seq' )
    {
        { [ { } ] [ "" ] }
        { [ 1array ] [ ] }
        { [ 2array ] [ " and " glue ] }
        [ unclip swap (quibble) ", " glue ]
    } switch ;

: quibble ( seq -- str ) (quibble) "{%s}" sprintf ;

{ } qw{ ABC } qw{ ABC DEF } qw{ ABC DEF G H }
[ quibble print ] 4 napply
