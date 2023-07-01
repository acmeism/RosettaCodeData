USING: assocs io.encodings.ascii io.files kernel math
math.statistics prettyprint sequences sorting ;

! Only consider words longer than two letters and words that
! contain elt.
: pare ( elt seq -- new-seq )
    [ [ member? ] keep length 2 > and ] with filter ;

: words ( input-str path -- seq )
    [ [ midpoint@ ] keep nth ] [ ascii file-lines pare ] bi* ;

: ?<= ( m n/f -- ? ) dup f = [ nip ] [ <= ] if ;

! Can we make sequence 1 with the elements in sequence 2?
: can-make? ( seq1 seq2 -- ? )
    [ histogram ] bi@ [ swapd at ?<= ] curry assoc-all? ;

: solve ( input-str path -- seq )
    [ words ] keepd [ can-make? ] curry filter ;

"ndeokgelw" "unixdict.txt" solve [ length ] sort-with .
