USING: fry io kernel math prettyprint sequences ;

! Push a sequence of 10 quotations
10 iota [
    '[ _ dup * ]        ! Push a quotation ( i -- i*i )
] map

{ 3 8 } [
    dup pprint " squared is " write
    over nth call .
] each
drop
