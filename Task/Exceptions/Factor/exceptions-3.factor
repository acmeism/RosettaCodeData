! Preferred exception handling
: try-foo
    [ foo ] [ foo-failed ] recover ;

: try-bar
    [ bar ] [ bar-errored ] [ bar-always ] cleanup ;

! Used rarely
[ "Fail" throw ] try   ! throws a "Fail"
[ "Fail" throw ] catch ! returns "Fail"
[ "Hi" print ] catch   ! returns f (looks the same as throwing f; don't throw f)
[ f throw ] catch      ! returns f, bad!  use recover or cleanup instead
