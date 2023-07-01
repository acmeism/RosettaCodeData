PROGRAM StackObject.pas;
{$IFDEF FPC}
    {$mode objfpc}{$H+}{$J-}{$m+}{$R+}
{$ELSE}
    {$APPTYPE CONSOLE}
{$ENDIF}
(*)

        Free Pascal Compiler version 3.2.0 [2020/06/14] for x86_64
        TheStack free and readable alternative at C/C++ Sidxeeds
        compiles natively to almost any platform, including raSidxberry PI *
        Can run independently from DELPHI / Lazarus

        For debian Linux: apt -y install fpc
        It contains a text IDE called fp

        This is an experiment for a stack that can handle almost any
        simple type of variable.

        What happens after retrieving the variable is TBD by you.

        https://www.freepascal.org/advantage.var
(*)


USES
        Classes   ,
        Crt       ,
        Variants  ;
        {$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined} // Use for variants

TYPE

    Stack   =   OBJECT

                    CONST

                        CrLf    =   #13#10  ;

                    TYPE

                        VariantArr = array  of variant ;

                    PRIVATE

                            Ar  :   VariantArr  ;

                            {$MACRO ON}
                                {$DEFINE STACKSIZE  :=  Length ( Ar )           * Ord ( Length ( Ar ) > 0 ) }
                                {$DEFINE TOP        :=  STACKSIZE - 1           * Ord ( STACKSIZE > 0 )     }
                                {$DEFINE SLEN       :=  length ( Ar [ TOP ] )   * Ord ( Length ( Ar [ TOP ] ) > 0 ) }

                            FUNCTION    IsEmpty             : boolean   ;
                            PROCEDURE   Print                           ;
                            FUNCTION    Pop                 : variant   ;
                            FUNCTION    Peep                : variant   ;
                            PROCEDURE   Push        ( item  : variant ) ;
                            FUNCTION    SecPop              : variant   ;

                    PUBLIC
                            CONSTRUCTOR Create                          ;

                END;


    CONSTRUCTOR Stack.Create ;

        BEGIN
                SetLength ( Ar, STACKSIZE ) ;
        END;

    FUNCTION    Stack.IsEmpty  : boolean ;

        BEGIN
                IsEmpty := ( STACKSIZE < 1 ) ;
        END;


    PROCEDURE   Stack.Print  ;

        VAR
                i   :   shortint ;
        BEGIN
                IF ( TOP < 1 ) or ( IsEmpty ) THEN
                    BEGIN
                        WriteLn ( CrLf + '<empty stack>' ) ;
                        EXIT ;
                    END;
                WriteLn ( CrLf , '<top>') ;

                FOR i := ( TOP )  DOWNTO 0 DO WriteLn ( Ar [ i ] ) ;
                WriteLn ( '<bottom>' ) ;
        END;


    FUNCTION    Stack.Pop : variant ;

        BEGIN
                IF IsEmpty THEN EXIT        ;
                Pop        := Ar [ TOP ]    ;
                SetLength  ( Ar, TOP )      ;
        END;


    FUNCTION    Stack.Peep  : variant ;

        BEGIN
                IF IsEmpty THEN EXIT        ;
                Peep        := Ar [ TOP ]   ;
        END;


    PROCEDURE   Stack.Push  ( item : variant ) ;

        BEGIN
                SetLength ( Ar, STACKSIZE + 1 ) ;
                Ar  [ TOP ]   := item           ;
        END;


    FUNCTION    Stack.SecPop : variant ;

        (*) Pop and Wipe    (*)

        BEGIN
                IF IsEmpty THEN EXIT                            ;
                SecPop      := Ar [ TOP ]                       ;
                Ar [ TOP ]  := StringOfChar ( #255  , SLEN )    ;
                Ar [ TOP ]  := StringOfChar ( #0    , SLEN )    ;
                SetLength  ( Ar, TOP )                          ;
        END;

VAR
        n   :   integer  ;
        r   :   real     ;
        S   :   string   ;
        So  :   Stack    ;


BEGIN

        So.Create                           ;
        So.Print                            ;
        n   := 23                           ;
        So.Push  ( n )                      ;
        S   := '3 guesses '                 ;
        So.Push  ( S )                      ;
        r   :=  1.23                        ;
        So.Push  ( r )                      ;
        WriteLn  ( 'Peep : ', So.Peep  )    ;
        So.Push  ( 'Nice Try' )             ;
        So.Print                            ;
        WriteLn                             ;
        WriteLn  ( 'SecPop : ',So.SecPop )  ;
        WriteLn  ( 'SecPop : ',So.SecPop )  ;
        WriteLn  ( 'SecPop : ',So.SecPop )  ;
        WriteLn  ( 'SecPop : ',So.SecPop )  ;
        So.Print                            ;
END.
