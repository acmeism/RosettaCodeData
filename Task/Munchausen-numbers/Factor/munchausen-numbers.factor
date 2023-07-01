USING: kernel math.functions math.ranges math.text.utils
prettyprint sequences ;

: munchausen? ( n -- ? )
    dup 1 digit-groups dup [ ^ ] 2map sum = ;

5000 [1,b] [ munchausen? ] filter .
