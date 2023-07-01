PROGRAM ExDynVar;

{$IFDEF FPC}
    {$mode objfpc}{$H+}{$J-}{R+}
{$ELSE}
    {$APPTYPE CONSOLE}
{$ENDIF}

(*)
    Free Pascal Compiler version 3.2.0 [2020/06/14] for x86_64
    The free and readable alternative at C/C++ speeds
    compiles natively to almost any platform, including raspberry PI

    This demo uses a dictionary because it is compiled: it cannot  make
    dynamic variables at runtime.
(*)

USES
    Generics.Collections,
    SysUtils,
    Variants;

TYPE

    Tdict =
    {$IFDEF FPC}
    specialize
    {$ENDIF}
     TDictionary < ansistring, variant > ;

VAR
    VarName:  ansistring;
    strValue: ansistring;
    VarValue:    variant;
    D:             Tdict;

    FUNCTION SetType ( strVal: ansistring ) : variant ;

    (*)
       If the value is numeric, store it as numeric, otherwise store it as ansistring
    (*)

        BEGIN

            TRY
                SetType := StrToFloat ( strVal ) ;
            EXCEPT
                SetType :=                strVal ;
            END;

        END;

BEGIN

    D := TDict.Create;
    REPEAT
        Write  ( 'Enter variable name : '  ) ;
        ReadLn ( VarName  ) ;
        Write  ( 'Enter variable Value : ' ) ;
        ReadLn ( strValue ) ;
        VarValue :=     SetType ( strValue ) ;
        TRY
            BEGIN
                D.AddOrSetValue ( VarName, VarValue ) ;
                Write                     ( VarName ) ;
                Write                     (  ' = '  ) ;
                WriteLn             ( D [ VarName ] ) ;
            END;
        EXCEPT
            WriteLn ( 'Something went wrong.. Try again' ) ;
        END;
    UNTIL ( strValue = '' ) ;
    D.Free;

END.
