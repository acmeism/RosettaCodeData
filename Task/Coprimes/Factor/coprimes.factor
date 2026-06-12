USING: io kernel math prettyprint sequences ;

: coprime? ( seq -- ? ) [ ] [ simple-gcd ] map-reduce 1 = ;

{
    { 21 15 }
    { 17 23 }
    { 36 12 }
    { 18 29 }
    { 60 15 }
    { 21 22 25 31 143 }
}
[ dup pprint coprime? [ " Coprime" write ] when nl ] each
