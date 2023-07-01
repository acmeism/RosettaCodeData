: if-older ( n true false -- )
    [ build > ] 2dip if ; inline

: when-older ( n true -- )
    [ ] if-older ; inline
: unless-older ( n false -- )
    [ [ ] ] dip if-older ; inline

900 [ "Your version of Factor is too old." print 1 exit ] when-older
