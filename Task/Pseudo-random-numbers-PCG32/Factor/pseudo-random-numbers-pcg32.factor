USING: accessors kernel locals math math.bitwise math.statistics
prettyprint sequences ;

CONSTANT: const 6364136223846793005

TUPLE: pcg32 state inc ;

: <pcg32> ( -- pcg32 )
    0x853c49e6748fea9b 0xda3e39cb94b95bdb pcg32 boa ;

:: next-int ( pcg -- n )
    pcg state>> :> old
    old const * pcg inc>> + 64 bits pcg state<<
    old -18 shift old bitxor -27 shift 32 bits :> shifted
    old -59 shift 32 bits :> r
    shifted r neg shift
    shifted r neg 31 bitand shift bitor 32 bits ;

: next-float ( pcg -- x ) next-int 1 32 shift /f ;

:: seed ( pcg st seq -- )
    0x0 pcg state<<
    seq 0x1 shift 1 bitor 64 bits pcg inc<<
    pcg next-int drop
    pcg state>> st + pcg state<<
    pcg next-int drop ;

! Task
<pcg32> 42 54 [ seed ] keepdd 5 [ dup next-int . ] times

987654321 1 [ seed ] keepdd
100,000 [ dup next-float 5 * >integer ] replicate nip
histogram .
