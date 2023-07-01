UNIT MRF;
{$mode Delphi} {$H+} {$J-} {$R+} (*)  https://www.freepascal.org/docs-html/prog/progch1.html   (*)

(*)

        Free Pascal Compiler version 3.2.0 [2020/06/14] for x86_64
        The free and readable alternative at C/C++ speeds
        compiles natively to almost any platform, including raspberry PI *
        Can run independently from DELPHI / Lazarus

        For debian Linux: apt -y install fpc
        It contains a text IDE called fp

        https://www.freepascal.org/advantage.var

(*)


INTERFACE

    USES
    Math,
    SysUtils,
    variants;
    {$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined} // Use for variants

    TYPE

        Varyray  = array of variant ;

        FunA  = FUNCTION     ( x   : variant   ) : variant   ;
        FunB  = PROCEDURE    ( x   : variant   ) ;
        FunC  = FUNCTION     ( x,y : variant   ) : variant   ;
        FunD  = FUNCTION     ( x,y : longint   ) : longint   ;
        FunE  = FUNCTION     ( x,y : variant   ) : variant   ;


        PROCEDURE   Show          ( x :               variant ) ;
        FUNCTION    Reverse       ( x : Varyray ) :   Varyray ;
        FUNCTION    Head          ( x : Varyray ) :   variant ;
        FUNCTION    Last          ( x : Varyray ) :   variant ;
        FUNCTION    Tail          ( x : Varyray ) :   Varyray ;
        FUNCTION    Take          ( y : variant ; x : Varyray ) : Varyray ;
        FUNCTION    Map           ( f : FunA ; x:     Varyray ) : Varyray ; overload ;
        PROCEDURE   Map           ( f : FunB ; x:     Varyray ) ;           overload ;
        FUNCTION    Map           ( f : FunC ; x, y:  Varyray ) : Varyray ; overload ;
        FUNCTION    Map           ( f : FunD ; x, y:  Varyray ) : Varyray ; overload ;
        FUNCTION    Filter        ( f : FunA ; x:     Varyray ) : Varyray ; overload ;
        FUNCTION    Filter        ( f : FunE ; y:     variant; x: Varyray ) : Varyray ; overload ;
        FUNCTION    FoldL         ( f : FunC ; x:     Varyray ) : variant ; overload ;
        FUNCTION    FoldL         ( f : FunD ; x:     Varyray ) : variant ; overload ;
        FUNCTION    FoldL         ( f : FunE ; y:     variant; x: Varyray ) : variant ; overload ;
        FUNCTION    Reduce        ( f : FunC ; x:     Varyray ) : variant ; overload ;
        FUNCTION    Reduce        ( f : FunD ; x:     Varyray ) : variant ; overload ;
        FUNCTION    Reduce        ( f : FunE ; y:     variant; x: Varyray ) : variant ; overload ;
        FUNCTION    FoldR         ( f : FunC ; x:     Varyray ) : variant ; overload ;
        FUNCTION    FoldR         ( f : FunD ; x:     Varyray ) : variant ; overload ;

(*) FOR TESTING (*)

        FUNCTION    RandFillInt   ( x:              variant ) : variant ;
        FUNCTION    RandFillReal  ( x:              variant ) : variant ;

        FUNCTION    AND_xy        ( x, y:           variant ) : variant ;
        FUNCTION    OR_xy         ( x, y:           variant ) : variant ;
        FUNCTION    AVG           ( x:              Varyray ) : variant ;
        FUNCTION    All           ( f: FunA ; x:    Varyray ) : variant ;
        FUNCTION    Any           ( f: FunA ; x:    Varyray ) : variant ;

        FUNCTION    Add           ( x, y:           variant ) : variant ;
        FUNCTION    Mult          ( x, y:           variant ) : variant ;
        FUNCTION    contain       ( x, y:           variant ) : variant ;
        FUNCTION    delete        ( x, y:           variant ) : variant ;

        FUNCTION    Add1          ( x:              variant ) : variant ;
        FUNCTION    sine          ( x:              variant ) : variant ;
        FUNCTION    cosine        ( x:              variant ) : variant ;
        FUNCTION    cotangens     ( x:              variant ) : variant ;
        FUNCTION    Is_Even       ( x:              variant ) : variant ;
        FUNCTION    Is_Odd        ( x:              variant ) : variant ;



IMPLEMENTATION


    PROCEDURE  Show ( x: variant ) ;
         BEGIN write( x, ' ' ) ; END ;



    FUNCTION    Reverse ( x : Varyray ) : Varyray ;

        VAR
            __  : varyray ;
            k   : integer ;

        BEGIN

            IF length ( x ) < Low ( x ) + 2  THEN Exit ;

            Setlength ( __,  length ( x ) );

            FOR k := Low  ( x ) to High ( x ) DO
                    __ [ k ] := x [ High ( x ) - k ] ;

            result := __ ;

            Setlength ( __,  0 );

        END;



    FUNCTION    Head ( x : Varyray ) : variant ;
        BEGIN result := x [ Low ( x ) ] ; END;



    FUNCTION    Last ( x : Varyray ) : variant ;
        BEGIN result := x [ High ( x ) ] ; END;



    FUNCTION    Tail ( x : Varyray ) : Varyray ;

        VAR
            __  : varyray ;
            k   : integer ;

        BEGIN

            Setlength ( __, High ( x ) );

            FOR k := Low  ( x ) + 1 to High ( x ) DO
                    __ [ k - 1 ] := x [ k ] ;

            result := __ ;

            Setlength ( __,  0 );

        END;



    FUNCTION    Take ( y : variant ; x : Varyray ) : Varyray ;

        VAR
            __  : varyray ;
            k   : integer ;

        BEGIN


            Setlength ( __, y );

            FOR k := Low  ( x ) to y - 1 DO
                    __ [ k ] := x [ k ] ;

            result := __ ;

            Setlength ( __,  0 );

        END;



     FUNCTION   Map ( f: FunA ;  x: Varyray ) : Varyray ;  overload ;

        VAR

            Ar  :   array of variant ;
            k   :   integer          ;

        BEGIN

            SetLength ( Ar, length ( x ) ) ;
            result  := Ar ;

            FOR k := Low ( Ar ) TO High ( Ar )  DO
                Ar [ k ] := f ( x [ k ] ) ;

            result  := Ar ;

            Setlength ( Ar,  0 );

        END;



    PROCEDURE   Map ( f: FunB ;  x: Varyray ) ; overload ;

        VAR

            k   :   integer ;

        BEGIN
                FOR k := Low ( x ) TO High ( x )  DO f ( x [ k ] ) ;
        END;



    FUNCTION    Map ( f: FunC ;  x, y: Varyray ) : Varyray ; overload ;

        VAR

            Ar  :   array of variant ;
            k   :   integer          ;

        BEGIN

            SetLength ( Ar, min ( length ( x ) , length ( y ) ) ) ;

            FOR k := Low ( Ar ) TO High ( Ar )  DO
                Ar [ k ] := f ( x [ k ] , y [ k ] ) ;

            result  := Ar ;

            Setlength ( Ar,  0 );

        END;



    FUNCTION    Map ( f: FunD ;  x, y: Varyray ) : Varyray ; overload ;

        VAR

            Ar  :   array of variant ;
            k   :   integer          ;

        BEGIN

            SetLength ( Ar, min ( length ( x ) , length ( y ) ) ) ;

            FOR k := Low ( Ar ) TO High ( Ar )  DO
                Ar [ k ] := f ( x [ k ] , y [ k ] ) ;

            result  := Ar ;

            Setlength ( Ar,  0 );

        END;



    FUNCTION    Map ( f: FunE ;  x: variant; y: Varyray ) : Varyray ; overload ;

        VAR

            Ar  :   array of variant ;
            k   :   integer          ;

        BEGIN

            SetLength ( Ar, min ( length ( x ) , length ( y ) ) ) ;

            FOR k := Low ( Ar ) TO High ( Ar )  DO
                Ar [ k ] := f ( x , y [ k ] ) ;

            result  := Ar ;

            Setlength ( Ar,  0 );

        END;



     FUNCTION   Filter ( f: FunA ;  x: Varyray ) : Varyray ; overload ;

        VAR

            Ar  :   array of variant ;
            __  :   variant          ;
            k   :   integer          ;
            len :   integer          ;

        BEGIN

            SetLength ( Ar, 0 ) ;
            result  := Ar ;

            FOR k := Low ( x ) TO High ( x )  DO
                BEGIN

                    __ := f ( x [ k ] ) ;

                    IF __ <> False THEN

                        BEGIN

                            len := Length ( Ar ) ;
                            SetLength ( Ar, len + 1 ) ;
                            Ar [ len ] := __ ;

                        END ;

                END ;

            result  := Ar ;

            Setlength ( Ar,  0 );
        END;



     FUNCTION   Filter ( f: FunE ;  y: variant; x: Varyray ) : Varyray ; overload ;

        VAR

            Ar  :   array of variant ;
            __  :   variant          ;
            k   :   integer          ;
            len :   integer          ;

        BEGIN

            SetLength ( Ar, 0 ) ;
            result  := Ar ;

            FOR k := Low ( x ) TO High ( x )  DO
                BEGIN

                    __ := f ( y, x [ k ] ) ;

                    IF __ <> False THEN

                        BEGIN

                            len := Length ( Ar ) ;
                            SetLength ( Ar, len + 1 ) ;
                            Ar [ len ] := __ ;

                        END ;

                END ;

            result  := Ar ;

            Setlength ( Ar,  0 );
        END;



     FUNCTION   FoldL ( f: FunC ; x: Varyray ) : variant ; overload ;

        VAR

            k   :   integer ;

        BEGIN

            result := x [ Low ( x ) ] ;

            FOR k := Low ( x ) + 1 TO High ( x ) DO
                result :=  f ( result , x [ k ] ) ;

        END ;



     FUNCTION   FoldL ( f: FunD ; x: Varyray ) : variant ; overload ;

        VAR

            k   :   integer ;

        BEGIN

            result := x [ Low ( x ) ] ;

            FOR k := Low ( x ) + 1 TO High ( x ) DO
                result :=  f ( result , x [ k ] ) ;

        END ;



     FUNCTION   FoldL ( f: FunE ; y: variant; x: Varyray ) : variant ; overload ;

        VAR

            k   :   integer ;

        BEGIN


            FOR k := Low ( x ) TO High ( x ) DO
                result :=  f ( y , x [ k ] ) ;

        END ;



     FUNCTION   Reduce ( f: FunC ; x: Varyray ) : variant ; overload ;
           BEGIN result := FoldL ( f , x ) ; END ;



     FUNCTION   Reduce ( f: FunD ; x: Varyray ) : variant ; overload ;
           BEGIN result := FoldL ( f , x ) ; END ;



     FUNCTION   Reduce ( f: FunE ; y: variant; x: Varyray ) : variant ; overload ;
           BEGIN result := FoldL ( f , y, x ) ; END ;



     FUNCTION   FoldR ( f: FunC ; x: Varyray ) : variant ; overload ;

        VAR

            k   :   integer ;

        BEGIN

            result := x [ High ( x ) ] ;

            FOR k := High ( x ) - 1 DOWNTO Low ( x ) DO
                result :=  f (  result, x [ k ] ) ;

        END ;



     FUNCTION   FoldR ( f: FunD ; x: Varyray ) : variant ; overload ;

        VAR

            k   :   integer ;

        BEGIN


            result := x [ High ( x ) ];

            FOR k := High ( x ) - 1 DOWNTO Low ( x ) DO
                result :=  f ( result, x [ k ] ) ;

        END ;



        (*)         TEST Functions                              (*)

(*)

        Special thanks to PascalDragon , winni & BobDog ( FreePascal.org ),
        who explained the specifics of the compiler.

(*)


    FUNCTION    Add  ( x, y: variant ) : variant ;
        BEGIN  result := x + y ; END ;



    FUNCTION    Add1 ( x: variant ) : variant ;
        BEGIN result := x + 1 ; END ;



    FUNCTION    AND_xy  ( x, y: variant ) : variant ;
        BEGIN  result := ( x and y ) = True ; END ;



    FUNCTION    AVG ( x: Varyray ) : variant ;

        VAR

            k   :   integer ;

        BEGIN

            result := 0.0 ;

            FOR k := Low ( x )  TO High ( x ) DO
                result :=  result + ( x [ k ] - result ) / ( k + 1 );

        END ;



    FUNCTION    Cosine  ( x: variant ) : variant ;
        BEGIN result := cos ( x ); END ;



    FUNCTION    Cotangens  ( x: variant ) : variant ;

        BEGIN

            IF ( x = 0 ) Then Exit ( 'Inf');

            result := cot ( x );

        END ;



    FUNCTION    Is_Even ( x: variant ) : variant ;

        BEGIN

                IF ( ( x mod 2 ) = 0 ) THEN
                    result := x
                ELSE
                    result := False

        END;



    FUNCTION    Mult( x, y: variant ) : variant ;
        BEGIN  result := x * y ; END ;



    FUNCTION    Contain ( x, y: variant ) : variant ;
        BEGIN  result := x = y ; END ;



    FUNCTION    Delete  ( x, y: variant ) : variant ;

        BEGIN

            IF ( x = y ) THEN Exit ( False ) ;

            result := y;

        END ;


    FUNCTION    Is_Odd ( x: variant ) : variant ;

        BEGIN

                IF ( ( x mod 2 ) <> 0 ) THEN
                    result := x
                ELSE
                    result := False

        END;



    FUNCTION    OR_xy  ( x, y: variant ) : variant ;
        BEGIN  result := ( x or y ) = True; END ;



    FUNCTION    RandFillInt   ( x: variant ) : variant ;
        BEGIN result := Random (  100 ) ; END ;



    FUNCTION    RandFillReal ( x: variant ) : variant ;

        VAR
            tmp :   real = 100.0 ;

        BEGIN result := ( Random (  ) ) * tmp  ; END ;



    FUNCTION    sine    ( x: variant ) : variant ;
        BEGIN result := sin ( x ); END ;



     FUNCTION All  ( f: FunA ; x: Varyray ) : variant ;

        VAR

            k   :   integer ;

        BEGIN

            result := True ;

            FOR k := Low ( x ) TO High ( x ) DO
                result :=  AND_xy ( result , f ( x [ k ] ) ) ;

        END ;



     FUNCTION Any    ( f: FunA ; x: Varyray ) : variant ;

        VAR

            k   :   integer ;

        BEGIN

            result := False ;

            FOR k := Low ( x ) TO High ( x ) DO
                result :=  OR_xy ( result , f ( x [ k ] ) ) ;

        END ;
END.


(*) === How to use in a program === (*)


program testMRF.pas;
{$mode Delphi} {$H+} {$J-} {$R+} (*)  https://www.freepascal.org/docs-html/prog/progch1.html   (*)
USES
    MRF,
       Math,
       SysUtils,
       Variants;
       {$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined} // Use for variants

VAR

    a,b,c   :   array of variant ;

    Acc     :   variant ;

BEGIN

    Randomize ;

    setlength ( a, 6  ) ;
    setlength ( b, 4  ) ;
    setlength ( c, 6 ) ;

    a       :=  Map     ( RandFillInt   , a     ) ;
                Map     ( show          , a     ) ;
                writeln ;

    b       :=  Map     ( RandFillInt   , b     ) ;
                Map     ( show          , b     ) ;
                writeln ;

    c       :=  Map     ( RandFillInt   , c     ) ;
                Map     ( show          , c     ) ;
                writeln ;

    Acc     :=  FoldL   ( add           , a     ) ;
                WriteLn ( 'Sum = '      , Acc   ) ;
                writeln ;

    Acc     :=  Reduce  ( contain       , 31, a ) ;
                WriteLn ( 'contains = ' , Acc   ) ;
                writeln ;

    c       :=  Filter  ( delete        , 31, a ) ;
                WriteLn ( 'del c :' ) ;
                Map     ( show          , c     ) ;
                writeln ;

    a       :=  Reverse ( c ) ;
                WriteLn ( 'reverse c :' ) ;
                Map     ( show          , a     ) ;
                writeln ;

    Acc     :=  avg     ( b ) ;
                WriteLn ( 'avg = '      , Acc   ) ;
                writeln ;

    c       :=  Map     ( cotangens     , b     ) ;
                writeln ( 'cot : ' ) ;
                Map     ( show          , c     ) ;
                writeln ;

    Acc     :=  FoldR   ( min           , b     ) ;
                WriteLn ( 'min = '      , Acc  );
                writeln ;

    Acc     :=  FoldR   ( max           , b     ) ;
                WriteLn ( 'max = '      , Acc  );
                writeln ;

                Map     ( show          , b     ) ;
    Acc     :=  All     ( Is_Odd        , b     ) ;
                writeln ;
                WriteLn ( 'All Is_Odd = '   , Acc   ) ;
                writeln ;

                Map     ( show           , b    ) ;
    Acc     :=  Any     ( Is_Even        , b    ) ;
                writeln ;
                WriteLn ( 'Any Is_Even = '  , Acc   ) ;
                writeln ;

    Acc     :=  Head    ( b ) ;
                WriteLn ( 'Head = '      , Acc   ) ;

    Acc     :=  Last    ( b ) ;
                WriteLn ( 'Last = '      , Acc   ) ;

                Map     ( show          , b     ) ;
    a       :=  Tail ( b ) ;
                writeln ;
                WriteLn ( 'Tail of b :' ) ;
                Map     ( show          , a     ) ;
                writeln ;

                Map     ( show          , b     ) ;
    a       :=  Take ( 2, b ) ;
                writeln ;
                WriteLn ( 'Take 2 from b :' ) ;
                Map     ( show          , a     ) ;
                writeln ;

    setlength ( c, 0 ) ;
    setlength ( b, 0 ) ;
    setlength ( a, 0 ) ;



END.
