USING: arrays combinators io kernel qw sequences ;
IN: rosetta-code.comma-quibble

: wrap ( str -- {str} ) "{" prepend "}" append ;
: quibble-pair ( seq -- str ) " and " join wrap ;
: quibble-list ( seq -- str )
    [ but-last ] [ last ] bi [ ", " join ] dip 2array
    quibble-pair ;
: comma-quibble ( seq -- ) dup length
{
  { 0 [ drop "{}" ] }
  { 1 [ first wrap ] }
  { 2 [ quibble-pair ] }
  [ drop quibble-list ]
} case print ;

{ } comma-quibble
qw{ ABC } comma-quibble
qw{ ABC DEF } comma-quibble
qw{ ABC DEF G H } comma-quibble
