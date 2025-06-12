======================================================================
(*)
    Save to ShortNotation.inc
    Use {$INCLUDE ShortNotation.inc} in order to load this file
    Load before any other .inc file
(*)

{$MACRO ON}
(*)     Shorthand mainly for lambdas (anonymous functions) (*)

    {$DEFINE Fn     :=   function }
    {$DEFINE Proc   :=  procedure }
    {$DEFINE spec   := specialize }
    {$DEFINE ref    :=  reference }
    {$DEFINE _      :=      begin }
    {$DEFINE __     :=        end }

(*)     defs for WriteLn    (*)
    {$DEFINE nl := #13#10}
    {$DEFINE tab := #9}
======================================================================
(*)
    Save to CompilerSwitches.inc
    Use {$INCLUDE CompilerSwitches.inc} in order to load this file
(*)

{$IFDEF FPC}
    {$MODE OBJFPC}
    {$M+}
    {$LONGSTRINGS ON}
    {$ASMMODE INTEL}
    {$Q+}
    {$RANGECHECKS ON}
    {$S+}
    {$TYPEDADDRESS ON}
    {$MODESWITCH EXCEPTIONS}
    {$MODESWITCH ADVANCEDRECORDS}
    {$MODESWITCH TYPEHELPERS}
    {$MODESWITCH FUNCTIONREFERENCES}
    {$MODESWITCH ANONYMOUSFUNCTIONS}
{$ELSE}
    {$APPTYPE CONSOLE}
{$ENDIF}


{$WARNINGS OFF W1033}
{$WARN 6058 OFF}
======================================================================
unit MRF3 ;

(*)


    (c) 2025 jpd - Free to use, experimental

    Free Pascal Compiler version 3.3.1 [2025/03/18] for x86_64

    Map Reduce Filter version with chaining, generics and lambdas

    https://www.freepascal.org/advantage.var


(*)

{$INCLUDE ShortNotation.inc}

{$INCLUDE CompilerSwitches.inc}

interface

uses

    Generics.Collections,
    Generics.Defaults,
    StrUtils,
    SysUtils,
    Variants
     ;

type

    V = Variant ;
    L = specialize TList<V> ;

    TMapperFunc     = ref to Fn  ( item: V ; index: Integer ): V ;
    TPredicateFunc  = ref to Fn  ( item: V ; index: Integer ): Boolean ;
    TFolderFunc     = ref to Fn  ( Acc: V ; item: V ; index: Integer ): V ;
    TCompareFunc    = ref to Fn  ( const A, B: V ): Integer ;

    TCollPipe = record
    private
        FData: L ;
    public
        constructor Create( Data: L ) ;
        Fn   Count: Integer;
        Fn   GroupBy(KeyFunc: TMapperFunc): spec TDictionary<V, L>;
        Fn   ForAll(Predicate: TPredicateFunc): Boolean;
        Fn   Map    ( Func: TMapperFunc )    : TCollPipe ;
        Fn   Filter ( Func: TPredicateFunc ) : TCollPipe ;
        Fn   Reduce ( Func: TFolderFunc ; initial: V ): V ;
        Fn   Sort   ( Compare: TCompareFunc ): TCollPipe ;
        Fn   Debug  ( const Msg: String )    : TCollPipe ;
        Fn   ToArray: L ;
    end ;

    Fn   List( const Elements: array of V ): L ;
    Fn   Pipe( Data: L ): TCollPipe ; inline ;
    proc DebugList(const List: L; const Msg: String);
    Fn SortAndDebug(const List: L; Compare: TCompareFunc; const Msg: String): L;

    (*)     Core FP Functions   (*)

    Fn   Map    ( const Arr: L ; Func: TMapperFunc ):       L ;
    Fn   Filter ( const Arr: L ; Func: TPredicateFunc ):    L ;
    Fn   Reduce ( const Arr: L ; Func: TFolderFunc ; initial: V ): V ;



implementation

    proc DebugList(const List: L; const Msg: String);
    begin
      Pipe(List).Debug(Msg); // Convert TList<V> to TCollPipe once
    end;

    Fn SortAndDebug(const List: L; Compare: TCompareFunc; const Msg: String): L;
    _
      Result := Pipe(List)
        .Sort(Compare)
        .Debug(Msg)
        .ToArray;
    __;

    Fn TCollPipe.Count: Integer;
    _
        Result := FData.Count;
    __;

    Fn TCollPipe.GroupBy(KeyFunc: TMapperFunc): spec TDictionary<V, L>;
    var
        i: Integer;
        key: V;
        group: L;
    _
        Result := spec TDictionary<V, L>.Create;
        for i := 0 to FData.Count - 1 do
        _
            key := KeyFunc(FData[i], i);
            if not Result.TryGetValue(key, group) then
            _
                group := L.Create;
                Result.Add(key, group);
            __;
            group.Add(FData[i]);
        __;
    __;

    Fn TCollPipe.ForAll(Predicate: TPredicateFunc): Boolean;
    var
        i: Integer;
    _
        Result := True;
        for i := 0 to FData.Count - 1 do
        _
            if not Predicate(FData[i], i) then
            _
                Result := False;
                Exit;
            __;
        __;
    __;


    Fn   List( const Elements: array of V ): L ;

        var    elem: V ;
        _
            Result := L.Create ;
            for elem in Elements do
                Result.Add( elem ) ;
        __ ;



    constructor TCollPipe.Create( Data: L ) ;
        _
            FData := L.Create ;
            FData.AddRange( Data ) ;
        __ ;



    Fn   TCollPipe.Map( Func: TMapperFunc ): TCollPipe ;
        _
            Result := TCollPipe.Create( MRF3.Map( FData, Func ) ) ;
        __ ;



    Fn   TCollPipe.Filter( Func: TPredicateFunc ): TCollPipe ;
        _
            Result := TCollPipe.Create( MRF3.Filter( FData, Func ) ) ;
        __ ;



    Fn   TCollPipe.Reduce( Func: TFolderFunc ; initial: V ): V ;
        _
            Result := MRF3.Reduce( FData, Func, initial ) ;
        __ ;



    Fn TCollPipe.Sort( Compare: TCompareFunc ): TCollPipe;
    var
        NewList: L;
    _
        NewList := L.Create;
        NewList.AddRange(FData);
        NewList.Sort(spec TComparer<V>.Construct(Compare));
        Result := TCollPipe.Create(NewList);
    __ ;



    Fn   TCollPipe.Debug( const Msg: String ): TCollPipe ;

        var
            i: Integer ;
            s: String ;
        _
            s := Msg + ' [ ' ;

            if FData.Count > 1 then
                for i := 0 to FData.Count - 2 do
                    s := s + VarToStr( FData[ i ] ) + ', '
            else
                i := -1 ;

            Writeln( s + VarToStr( FData[ i + 1 ] ), ' ]' ) ;
            Result := Self ;
        __ ;



    Fn   TCollPipe.ToArray: L ;
        _
            Result := L.Create ;
            Result.AddRange( FData ) ;
        __ ;



    Fn   Pipe( Data: L ): TCollPipe ;
        _
            Result := TCollPipe.Create( Data ) ;
        __ ;



    Fn   Map( const Arr: L ; Func: TMapperFunc ): L ;

        var    i: Integer ;
        _
            Result := L.Create ;
            for i := 0 to Arr.Count - 1 do
                Result.Add( Func( Arr[ i ], i ) ) ;
        __ ;



    Fn   Filter( const Arr: L ; Func: TPredicateFunc ): L ;

        var    i: Integer ;
        _
            Result := L.Create ;
            for i := 0 to Arr.Count - 1 do
                if Func( Arr[ i ], i ) then
                    Result.Add( Arr[ i ] ) ;
        __ ;



    Fn   Reduce( const Arr: L ; Func: TFolderFunc ; initial: V ): V ;

        var    i: Integer ;
        _
            Result := initial ;
            for i := 0 to Arr.Count - 1 do
                Result := Func( Result, Arr[ i ], i ) ;
        __ ;

end.    ( * )     unit MRF3   ( * )

======================================================================
program testMRF3;

{$include ShortNotation.inc}

{$INCLUDE CompilerSwitches.inc}

uses

    Math,
    MRF3,
    StrUtils,
    SysUtils,
    Variants
    ;


 Fn  IsNumber( item: V ): Boolean ;

    _
        Result := VarIsNumeric( item ) and not VarIsBool( item ) ;
    __;


 Fn  CompareVariants( const A, B: V ): Integer ;

    _

        if VarIsNumeric( A ) and VarIsNumeric( B ) then
            Exit( CompareValue( Double( A ), Double( B ) ) ) ;

        if VarIsStr( A ) and VarIsStr( B ) then
            Exit( CompareText( A, B ) ) ;

        (*) Fallback: priority ( booleans < numbers < strings < )  (*)

        Result := ( Ord( VarIsStr( A ) ) - Ord( VarIsStr( B ) ) );
    __;

(*)         MAIN Line       (*)

    var
        Data :      L ;
        Total: Double ;

    _
        try
            Writeln( '=== MRF3 Unit Test ===' ) ;

            Data := List( [ 15, 2.5, 'Apple', True, 7, 'banana', False ] ) ;

            Pipe( Data )
                .Debug( 'Original:' )
                .Sort( @CompareVariants )
                .Debug( 'Sorted:' ) ;

            Total := Pipe( Data )

           .Filter (   Fn ( item: V; index: Integer ) : Boolean
                            _   Result := IsNumber( item ) ;
                            __
                    )

           .Map    (   Fn ( item: V; index: Integer ) : V
                            _   Result := Double( item ) * 2 ;
                            __
                    )

           .Reduce (   Fn ( Acc: V; item: V; index: Integer ): V
                            _   Result := Double( Acc ) + Double( item ) ;
                            __
                    , 0.0
                    )
            ;

            Writeln( 'Numeric sum x2: ', Total:0:2 ) ;

        except
            on E: Exception do
                Writeln( 'Error: ', E.Message ) ;
        end;

        Readln;

end.    (*)     program testMRF3    (*)
======================================================================
