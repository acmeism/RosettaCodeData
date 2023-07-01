my @char-groups =
    ['a' .. 'z'],
    ['A' .. 'Z'],
    ['0' .. '9'],
    < $ % & \ ` ~ ! * + , - . / :  ;  = ? @ ^ _  ~ [ ] ( ) { | } # ' " \< \> >.Array;

subset MinimumPasswordLength of  Int where * >= 4;
subset NumberOfPasswords     of UInt where * != 0;

sub MAIN( NumberOfPasswords :c(:$count) = 1, MinimumPasswordLength :l(:$length) = 8, Str :x(:$exclude) = '' ) {
    &USAGE() if 1 == (.comb ∖ $exclude.comb).elems for @char-groups;
    .say for password-characters($length, $exclude )
        .map( *.split(' ') )
        .map( *.pick: Inf ) # shuffle, so we don't get a predictable pattern
        .map( *.join )
        .head( $count );
}

sub password-characters( $len, $exclude ) {
    ( (( char-groups($exclude)       xx Inf ).map: *.pick).batch(     4)
     Z~
      (( char-groups($exclude, $len) xx Inf ).map: *.pick).batch($len-4) )
}

multi char-groups( $exclude )              { | @char-groups.map( * (-) $exclude.comb ) }
multi char-groups( $exclude, $max-weight ) { flat (char-groups($exclude)>>.keys.map: {$_ xx ^$max-weight .roll}) }

sub USAGE() {
    say qq:to/END/;
    Specify a length:              -l=10    (minimum 4)
    Specify a count:               -c=5     (minimum 1)
    Specify characters to exclude: -x=xkcd  (optional)
    Password must have at least one of each: lowercase letter, uppercase letter, digit, punctuation.
   END
}
