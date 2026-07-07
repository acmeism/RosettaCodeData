Program FastLucasGMP;
{$mode objfpc}{$H+}{$J-}
(*)
   ============================================================================
   Fast Lucas Number Calculator – arbitrary P,Q + Lucas‑Lehmer test
   ----------------------------------------------------------------------------
   2026.07.02  –  Extended for V_n(P,Q) and added Lucas‑Lehmer demo
   Author: jpd & DeepSeek
   Description: Compute V_n(P,Q) mod m using multiple algorithms.
   ============================================================================
   Usage:
     ./FastLucasGMP n [-a=algorithm] [-P=<P>] [-Q=<Q>] [-m=<mod>] [-benchmark]
     ./FastLucasGMP -lucaslehmer=<p> [-P=<P>] [-Q=<Q>]   (default P=4, Q=1)
   ============================================================================
*)

Uses
    SysUtils,
    DateUtils,
    Gmp;

Type
    TMatrix = Record
        a, b, c, d: mpz_t;
    End;

    TAlgorithm = (algMatrix, algFastDoubling, algIterative, algHybrid);

// ---------- Global parameters ----------
var
    UseModulus: boolean = False;
    Modulus: mpz_t;
    Pparam, Qparam: mpz_t;          // Current sequence parameters (P,Q)
    LucasLehmerMode: boolean = False;
    LL_exponent: Integer;

// ---------- Utility: file name ----------
function Fname (): string;
begin
    FName := ExtractFileName(ParamStr(0));
end;

// ---------- Matrix helper functions (unchanged) ----------
Procedure InitMatrix(Var m: TMatrix; a, b, c, d: Integer);
Begin
    mpz_init_set_si(m.a, a);
    mpz_init_set_si(m.b, b);
    mpz_init_set_si(m.c, c);
    mpz_init_set_si(m.d, d);
End;

Procedure ClearMatrix(Var m: TMatrix);
Begin
    mpz_clear(m.a);
    mpz_clear(m.b);
    mpz_clear(m.c);
    mpz_clear(m.d);
End;

Procedure MatrixMul(Var R, A, B: TMatrix);
Var
    temp1, temp2, temp3, temp4: mpz_t;
Begin
    mpz_init(temp1);
    mpz_init(temp2);
    mpz_init(temp3);
    mpz_init(temp4);

    mpz_mul(temp1, A.a, B.a);
    mpz_mul(temp2, A.b, B.c);
    mpz_add(temp1, temp1, temp2);

    mpz_mul(temp2, A.a, B.b);
    mpz_mul(temp3, A.b, B.d);
    mpz_add(temp2, temp2, temp3);

    mpz_mul(temp3, A.c, B.a);
    mpz_mul(temp4, A.d, B.c);
    mpz_add(temp3, temp3, temp4);

    mpz_mul(temp4, A.c, B.b);
    mpz_mul(R.d, A.d, B.d);
    mpz_add(temp4, temp4, R.d);

    mpz_set(R.a, temp1);
    mpz_set(R.b, temp2);
    mpz_set(R.c, temp3);
    mpz_set(R.d, temp4);

    mpz_clear(temp1);
    mpz_clear(temp2);
    mpz_clear(temp3);
    mpz_clear(temp4);
End;

// ============ MODULAR HELPER FUNCTIONS ============
Procedure mpz_addmod(dest, a, b, modval: mpz_t);
Begin
    mpz_add(dest, a, b);
    mpz_mod(dest, dest, modval);
End;

Procedure mpz_submod(dest, a, b, modval: mpz_t);
Begin
    mpz_sub(dest, a, b);
    if mpz_cmp_ui(dest, 0) < 0 then
        mpz_add(dest, dest, modval);
End;

Procedure mpz_mulmod(dest, a, b, modval: mpz_t);
Begin
    mpz_mul(dest, a, b);
    mpz_mod(dest, dest, modval);
End;

Procedure mpz_add_si_mod(dest, a: mpz_t; val: Int64; modval: mpz_t);
Begin
    if val >= 0 then
        mpz_add_ui(dest, a, QWord(val))
    else
        mpz_sub_ui(dest, a, QWord(-val));
    mpz_mod(dest, dest, modval);
End;

Procedure mpz_mul_si_mod(dest, a: mpz_t; val: Int64; modval: mpz_t);
Begin
    if val >= 0 then
        mpz_mul_ui(dest, a, QWord(val))
    else
    begin
        mpz_mul_ui(dest, a, QWord(-val));
        mpz_neg(dest, dest);
    end;
    mpz_mod(dest, dest, modval);
End;

// ============ ORIGINAL INTEGER ALGORITHMS (unchanged) ============

Procedure LucasMatrix(n: Int64; Var result: mpz_t);
Var
    Base, ResultMat, TempMat: TMatrix;
    mask: QWord;
    abs_n: QWord;
    startTime, endTime: TDateTime;
    temp1: mpz_t;
Begin
    startTime := Now;
    mpz_init(temp1);

    InitMatrix(Base, 0, 1, 1, 1);
    InitMatrix(ResultMat, 1, 0, 0, 1);
    InitMatrix(TempMat, 0, 0, 0, 0);

    If n >= 0 Then
        abs_n := QWord(n)
    Else
        abs_n := QWord(-n);

    mask := 1;
    While mask <= abs_n Do
    Begin
        If (abs_n And mask) <> 0 Then
        Begin
            MatrixMul(TempMat, ResultMat, Base);
            mpz_set(ResultMat.a, TempMat.a);
            mpz_set(ResultMat.b, TempMat.b);
            mpz_set(ResultMat.c, TempMat.c);
            mpz_set(ResultMat.d, TempMat.d);
        End;
        MatrixMul(TempMat, Base, Base);
        mpz_set(Base.a, TempMat.a);
        mpz_set(Base.b, TempMat.b);
        mpz_set(Base.c, TempMat.c);
        mpz_set(Base.d, TempMat.d);
        mask := mask Shl 1;
    End;

    // L(n) = ResultMat.a * 2 + ResultMat.b
    mpz_mul_ui(temp1, ResultMat.a, 2);
    mpz_add(result, temp1, ResultMat.b);

    ClearMatrix(Base);
    ClearMatrix(ResultMat);
    ClearMatrix(TempMat);
    mpz_clear(temp1);

    endTime := Now;
    WriteLn('Matrix method time: ', MilliSecondsBetween(endTime, startTime), ' ms');
End;

Procedure FastDoublingIterativeLucas(n: QWord; Var result: mpz_t);
Var
    a, b, c, d, temp1, temp2: mpz_t;
    mask: QWord;
    k: QWord;
    sign: Integer;
Begin
    mpz_init_set_ui(a, 2);   // L(0) = 2
    mpz_init_set_ui(b, 1);   // L(1) = 1
    mpz_init(c);
    mpz_init(d);
    mpz_init(temp1);
    mpz_init(temp2);

    mask := 1;
    While mask <= n Do
        mask := mask Shl 1;
    mask := mask Shr 1;

    k := 0;
    While mask > 0 Do
    Begin
        If (k Mod 2) = 0 Then sign := 1 Else sign := -1;

        // L(2k) = a^2 - 2*sign
        mpz_mul(temp1, a, a);
        If sign = 1 Then
            mpz_sub_ui(c, temp1, 2)
        Else
            mpz_add_ui(c, temp1, 2);

        // L(2k+1) = a*b - sign
        mpz_mul(temp1, a, b);
        If sign = 1 Then
            mpz_sub_ui(d, temp1, 1)
        Else
            mpz_add_ui(d, temp1, 1);

        If (n And mask) <> 0 Then
        Begin
            mpz_add(temp1, d, c);
            mpz_set(a, d);
            mpz_set(b, temp1);
            k := 2*k + 1;
        End
        Else
        Begin
            mpz_set(a, c);
            mpz_set(b, d);
            k := 2*k;
        End;
        mask := mask Shr 1;
    End;

    mpz_set(result, a);

    mpz_clear(a);
    mpz_clear(b);
    mpz_clear(c);
    mpz_clear(d);
    mpz_clear(temp1);
    mpz_clear(temp2);
End;

Procedure LucasFastDoubling(n: Int64; Var result: mpz_t);
Var
    startTime, endTime: TDateTime;
    fn: mpz_t;
    abs_n: QWord;
Begin
    startTime := Now;
    If n >= 0 Then
        abs_n := QWord(n)
    Else
        abs_n := QWord(-n);

    mpz_init(fn);
    FastDoublingIterativeLucas(abs_n, fn);

    If n < 0 Then
    Begin
        If (abs_n Mod 2) = 1 Then
            mpz_neg(fn, fn);
    End;

    mpz_set(result, fn);
    mpz_clear(fn);
    endTime := Now;
    WriteLn('Fast doubling method time: ', MilliSecondsBetween(endTime, startTime), ' ms');
End;

Procedure LucasIterative(n: Integer; Var result: mpz_t);
Var
    a, b, temp: mpz_t;
    i: Integer;
    abs_n: Integer;
    startTime, endTime: TDateTime;
Begin
    startTime := Now;
    mpz_init(a);
    mpz_init(b);
    mpz_init(temp);

    abs_n := Abs(n);
    If abs_n = 0 Then
        mpz_set_si(result, 2)
    Else If abs_n = 1 Then
        mpz_set_si(result, 1)
    Else
    Begin
        mpz_set_si(a, 2);
        mpz_set_si(b, 1);
        For i := 2 To abs_n Do
        Begin
            mpz_add(temp, a, b);
            mpz_set(a, b);
            mpz_set(b, temp);
        End;
        mpz_set(result, b);
    End;

    If n < 0 Then
    Begin
        If (abs_n Mod 2) = 1 Then
            mpz_neg(result, result);
    End;

    mpz_clear(a);
    mpz_clear(b);
    mpz_clear(temp);
    endTime := Now;
    WriteLn('Iterative method time: ', MilliSecondsBetween(endTime, startTime), ' ms');
End;

// ============ INTEGER HYBRID (unchanged) ============
Procedure LucasHybrid(n: Int64; Var result: mpz_t);
Var
    startTime, endTime: TDateTime;
    LDict: array of record
        key: QWord;
        value: mpz_t;
    end;
    DivMap: array of record
        key: QWord;
        divisor: QWord;
    end;
    i, j, idx: Integer;
    a, divBy, nextNum: QWord;
    temp1, temp2, temp3, temp4: mpz_t;
    sign: Integer;
    abs_n: QWord;
    target: QWord;
    sortedKeys: array of QWord;
    idx1, idx2: Integer;

    Function FindL(key: QWord): Integer;
    Var i: Integer;
    Begin
        For i := 0 To Length(LDict) - 1 Do
            If LDict[i].key = key Then
            Begin
                Result := i;
                Exit;
            End;
        Result := -1;
    End;

    Procedure AddL(key: QWord);
    Begin
        SetLength(LDict, Length(LDict) + 1);
        LDict[Length(LDict) - 1].key := key;
        mpz_init(LDict[Length(LDict) - 1].value);
    End;

    Procedure EnsureLPlusOne(a: QWord);
    Var
        idx0, idx1: Integer;
    Begin
        If FindL(a + 1) >= 0 Then Exit;
        idx0 := FindL(a);
        idx1 := FindL(a - 1);
        If (idx0 < 0) or (idx1 < 0) Then
        Begin
            WriteLn('Error: Cannot compute L(', a+1, ')');
            Halt(1);
        End;
        AddL(a + 1);
        mpz_add(LDict[Length(LDict) - 1].value, LDict[idx0].value, LDict[idx1].value);
    End;

Begin
    startTime := Now;
    mpz_init(temp1);
    mpz_init(temp2);
    mpz_init(temp3);
    mpz_init(temp4);

    If n >= 0 Then
        abs_n := QWord(n)
    Else
        abs_n := QWord(-n);

    target := abs_n;

    SetLength(LDict, 9);
    For i := 0 To 8 Do
    Begin
        LDict[i].key := QWord(i);
        mpz_init(LDict[i].value);
    End;
    mpz_set_ui(LDict[0].value, 2);
    mpz_set_ui(LDict[1].value, 1);
    mpz_set_ui(LDict[2].value, 3);
    mpz_set_ui(LDict[3].value, 4);
    mpz_set_ui(LDict[4].value, 7);
    mpz_set_ui(LDict[5].value, 11);
    mpz_set_ui(LDict[6].value, 18);
    mpz_set_ui(LDict[7].value, 29);
    mpz_set_ui(LDict[8].value, 47);

    If abs_n <= 8 Then
    Begin
        idx := FindL(abs_n);
        If idx >= 0 Then
            mpz_set(result, LDict[idx].value);
        If (n < 0) And ((abs_n Mod 2) = 1) Then
            mpz_neg(result, result);
        For i := 0 To 8 Do
            mpz_clear(LDict[i].value);
        mpz_clear(temp1);
        mpz_clear(temp2);
        mpz_clear(temp3);
        mpz_clear(temp4);
        endTime := Now;
        WriteLn('Hybrid method time: ', MilliSecondsBetween(endTime, startTime), ' ms');
        Exit;
    End;

    SetLength(DivMap, 0);
    a := abs_n;
    While a > 1 Do
    Begin
        If (a Mod 3) = 0 Then divBy := 3 Else divBy := 2;
        a := a Div divBy;
        SetLength(DivMap, Length(DivMap) + 1);
        DivMap[Length(DivMap) - 1].key := a;
        DivMap[Length(DivMap) - 1].divisor := divBy;
    End;
    SetLength(DivMap, Length(DivMap) + 1);
    DivMap[Length(DivMap) - 1].key := a;
    DivMap[Length(DivMap) - 1].divisor := divBy;

    SetLength(sortedKeys, Length(DivMap));
    For i := 0 To Length(DivMap) - 1 Do
        sortedKeys[i] := DivMap[i].key;
    For i := 0 To Length(sortedKeys) - 2 Do
        For j := i + 1 To Length(sortedKeys) - 1 Do
            If sortedKeys[i] > sortedKeys[j] Then
            Begin
                a := sortedKeys[i];
                sortedKeys[i] := sortedKeys[j];
                sortedKeys[j] := a;
            End;

    Write('Operations: ');

    For i := 0 To Length(sortedKeys) - 1 Do
    Begin
        a := sortedKeys[i];
        divBy := 0;
        For j := 0 To Length(DivMap) - 1 Do
            If DivMap[j].key = a Then
            Begin
                divBy := DivMap[j].divisor;
                Break;
            End;
        If divBy = 0 Then Continue;

        nextNum := a * divBy;

        If (a Mod 2) = 0 Then sign := 1 Else sign := -1;

        If divBy = 2 Then
        Begin
            Write('² ');
            j := FindL(a - 1);
            idx := FindL(a);
            If (j < 0) or (idx < 0) Then
            Begin
                WriteLn('Error: Missing base Lucas numbers for doubling at a=', a);
                Halt(1);
            End;

            // L(2a)
            AddL(nextNum);
            mpz_mul(temp1, LDict[idx].value, LDict[idx].value);
            If sign = 1 Then
                mpz_sub_ui(LDict[Length(LDict) - 1].value, temp1, 2)
            Else
                mpz_add_ui(LDict[Length(LDict) - 1].value, temp1, 2);

            // L(2a+1)
            EnsureLPlusOne(a);
            idx1 := FindL(a+1);
            AddL(nextNum + 1);
            mpz_mul(temp1, LDict[idx].value, LDict[idx1].value);
            If sign = 1 Then
                mpz_sub_ui(LDict[Length(LDict) - 1].value, temp1, 1)
            Else
                mpz_add_ui(LDict[Length(LDict) - 1].value, temp1, 1);

            // neighbours
            AddL(nextNum - 1);
            j := FindL(nextNum + 1);
            idx := FindL(nextNum);
            mpz_sub(LDict[Length(LDict) - 1].value, LDict[j].value, LDict[idx].value);

            AddL(nextNum + 2);
            j := FindL(nextNum + 1);
            idx := FindL(nextNum);
            mpz_add(LDict[Length(LDict) - 1].value, LDict[j].value, LDict[idx].value);

            If (nextNum - 1 = target) or (nextNum = target) or (nextNum + 1 = target) or (nextNum + 2 = target) Then
                Break;
        End
        Else If divBy = 3 Then
        Begin
            Write('³ ');
            idx := FindL(a);
            If idx < 0 Then
            Begin
                WriteLn('Error: Missing L(a) for tripling at a=', a);
                Halt(1);
            End;
            EnsureLPlusOne(a);
            idx1 := FindL(a + 1);

            // L(3a)
            AddL(nextNum);
            mpz_mul(temp1, LDict[idx].value, LDict[idx].value);
            If sign = 1 Then
                mpz_sub_ui(temp1, temp1, 3)
            Else
                mpz_add_ui(temp1, temp1, 3);
            mpz_mul(LDict[Length(LDict) - 1].value, LDict[idx].value, temp1);

            // L(3a+1)
            AddL(nextNum + 1);
            mpz_mul(temp1, LDict[idx].value, LDict[idx].value);
            mpz_mul(temp1, temp1, LDict[idx1].value);
            mpz_add(temp2, LDict[idx].value, LDict[idx1].value);
            If sign = 1 Then
                mpz_sub(LDict[Length(LDict) - 1].value, temp1, temp2)
            Else
                mpz_add(LDict[Length(LDict) - 1].value, temp1, temp2);

            // neighbours
            AddL(nextNum + 2);
            j := FindL(nextNum + 1);
            idx2 := FindL(nextNum);
            mpz_add(LDict[Length(LDict) - 1].value, LDict[j].value, LDict[idx2].value);

            AddL(nextNum - 1);
            j := FindL(nextNum + 1);
            idx2 := FindL(nextNum);
            mpz_sub(LDict[Length(LDict) - 1].value, LDict[j].value, LDict[idx2].value);

            AddL(nextNum + 3);
            j := FindL(nextNum + 2);
            idx2 := FindL(nextNum + 1);
            mpz_add(LDict[Length(LDict) - 1].value, LDict[j].value, LDict[idx2].value);

            If (nextNum - 1 = target) or (nextNum = target) or (nextNum + 1 = target) or
               (nextNum + 2 = target) or (nextNum + 3 = target) Then
                Break;
        End;
    End;

    WriteLn;

    idx := FindL(target);
    If idx < 0 Then
    Begin
        WriteLn('Error: Could not compute L(', n, ')');
        Halt(1);
    End;
    mpz_set(result, LDict[idx].value);

    If (n < 0) And ((abs_n Mod 2) = 1) Then
        mpz_neg(result, result);

    For i := 0 To Length(LDict) - 1 Do
        mpz_clear(LDict[i].value);
    mpz_clear(temp1);
    mpz_clear(temp2);
    mpz_clear(temp3);
    mpz_clear(temp4);

    endTime := Now;
    WriteLn('Hybrid method time: ', MilliSecondsBetween(endTime, startTime), ' ms');
End;

// ============ MODULAR HYBRID (unchanged) ============
Procedure LucasHybridMod(n: Int64; Var result: mpz_t; modval: mpz_t);
Var
    startTime, endTime: TDateTime;
    LDict: array of record
        key: QWord;
        value: mpz_t;
    end;
    DivMap: array of record
        key: QWord;
        divisor: QWord;
    end;
    i, j, idx: Integer;
    a, divBy, nextNum: QWord;
    temp1, temp2, temp3, temp4: mpz_t;
    sign: Integer;
    abs_n: QWord;
    target: QWord;
    sortedKeys: array of QWord;
    idx1, idx2: Integer;

    Function FindL(key: QWord): Integer;
    Var i: Integer;
    Begin
        For i := 0 To Length(LDict) - 1 Do
            If LDict[i].key = key Then
            Begin
                Result := i;
                Exit;
            End;
        Result := -1;
    End;

    Procedure AddL(key: QWord);
    Begin
        SetLength(LDict, Length(LDict) + 1);
        LDict[Length(LDict) - 1].key := key;
        mpz_init(LDict[Length(LDict) - 1].value);
    End;

    Procedure EnsureLPlusOne(a: QWord);
    Var
        idx0, idx1: Integer;
    Begin
        If FindL(a + 1) >= 0 Then Exit;
        idx0 := FindL(a);
        idx1 := FindL(a - 1);
        If (idx0 < 0) or (idx1 < 0) Then
        Begin
            WriteLn('Error: Cannot compute L(', a+1, ') mod m');
            Halt(1);
        End;
        AddL(a + 1);
        mpz_add(LDict[Length(LDict) - 1].value, LDict[idx0].value, LDict[idx1].value);
        mpz_mod(LDict[Length(LDict) - 1].value, LDict[Length(LDict) - 1].value, modval);
    End;

Begin
    startTime := Now;
    mpz_init(temp1);
    mpz_init(temp2);
    mpz_init(temp3);
    mpz_init(temp4);

    If n >= 0 Then
        abs_n := QWord(n)
    Else
        abs_n := QWord(-n);

    target := abs_n;

    SetLength(LDict, 9);
    For i := 0 To 8 Do
    Begin
        LDict[i].key := QWord(i);
        mpz_init(LDict[i].value);
    End;
    mpz_set_ui(LDict[0].value, 2); mpz_mod(LDict[0].value, LDict[0].value, modval);
    mpz_set_ui(LDict[1].value, 1); mpz_mod(LDict[1].value, LDict[1].value, modval);
    mpz_set_ui(LDict[2].value, 3); mpz_mod(LDict[2].value, LDict[2].value, modval);
    mpz_set_ui(LDict[3].value, 4); mpz_mod(LDict[3].value, LDict[3].value, modval);
    mpz_set_ui(LDict[4].value, 7); mpz_mod(LDict[4].value, LDict[4].value, modval);
    mpz_set_ui(LDict[5].value, 11); mpz_mod(LDict[5].value, LDict[5].value, modval);
    mpz_set_ui(LDict[6].value, 18); mpz_mod(LDict[6].value, LDict[6].value, modval);
    mpz_set_ui(LDict[7].value, 29); mpz_mod(LDict[7].value, LDict[7].value, modval);
    mpz_set_ui(LDict[8].value, 47); mpz_mod(LDict[8].value, LDict[8].value, modval);

    If abs_n <= 8 Then
    Begin
        idx := FindL(abs_n);
        If idx >= 0 Then
            mpz_set(result, LDict[idx].value);
        If (n < 0) And ((abs_n Mod 2) = 1) Then
        Begin
            mpz_sub(result, modval, result);
            mpz_mod(result, result, modval);
        End;
        For i := 0 To 8 Do
            mpz_clear(LDict[i].value);
        mpz_clear(temp1);
        mpz_clear(temp2);
        mpz_clear(temp3);
        mpz_clear(temp4);
        endTime := Now;
        WriteLn('Hybrid (mod) time: ', MilliSecondsBetween(endTime, startTime), ' ms');
        Exit;
    End;

    SetLength(DivMap, 0);
    a := abs_n;
    While a > 1 Do
    Begin
        If (a Mod 3) = 0 Then divBy := 3 Else divBy := 2;
        a := a Div divBy;
        SetLength(DivMap, Length(DivMap) + 1);
        DivMap[Length(DivMap) - 1].key := a;
        DivMap[Length(DivMap) - 1].divisor := divBy;
    End;
    SetLength(DivMap, Length(DivMap) + 1);
    DivMap[Length(DivMap) - 1].key := a;
    DivMap[Length(DivMap) - 1].divisor := divBy;

    SetLength(sortedKeys, Length(DivMap));
    For i := 0 To Length(DivMap) - 1 Do
        sortedKeys[i] := DivMap[i].key;
    For i := 0 To Length(sortedKeys) - 2 Do
        For j := i + 1 To Length(sortedKeys) - 1 Do
            If sortedKeys[i] > sortedKeys[j] Then
            Begin
                a := sortedKeys[i];
                sortedKeys[i] := sortedKeys[j];
                sortedKeys[j] := a;
            End;

    Write('Operations (mod): ');

    For i := 0 To Length(sortedKeys) - 1 Do
    Begin
        a := sortedKeys[i];
        divBy := 0;
        For j := 0 To Length(DivMap) - 1 Do
            If DivMap[j].key = a Then
            Begin
                divBy := DivMap[j].divisor;
                Break;
            End;
        If divBy = 0 Then Continue;

        nextNum := a * divBy;

        If (a Mod 2) = 0 Then sign := 1 Else sign := -1;

        If divBy = 2 Then
        Begin
            Write('² ');
            j := FindL(a - 1);
            idx := FindL(a);
            If (j < 0) or (idx < 0) Then
            Begin
                WriteLn('Error: Missing base for doubling at a=', a);
                Halt(1);
            End;

            AddL(nextNum);
            mpz_mul(temp1, LDict[idx].value, LDict[idx].value);
            If sign = 1 Then
                mpz_sub_ui(LDict[Length(LDict) - 1].value, temp1, 2)
            Else
                mpz_add_ui(LDict[Length(LDict) - 1].value, temp1, 2);
            mpz_mod(LDict[Length(LDict) - 1].value, LDict[Length(LDict) - 1].value, modval);

            EnsureLPlusOne(a);
            idx1 := FindL(a+1);
            AddL(nextNum + 1);
            mpz_mul(temp1, LDict[idx].value, LDict[idx1].value);
            If sign = 1 Then
                mpz_sub_ui(LDict[Length(LDict) - 1].value, temp1, 1)
            Else
                mpz_add_ui(LDict[Length(LDict) - 1].value, temp1, 1);
            mpz_mod(LDict[Length(LDict) - 1].value, LDict[Length(LDict) - 1].value, modval);

            AddL(nextNum - 1);
            j := FindL(nextNum + 1);
            idx2 := FindL(nextNum);
            mpz_sub(LDict[Length(LDict) - 1].value, LDict[j].value, LDict[idx2].value);
            mpz_mod(LDict[Length(LDict) - 1].value, LDict[Length(LDict) - 1].value, modval);

            AddL(nextNum + 2);
            j := FindL(nextNum + 1);
            idx2 := FindL(nextNum);
            mpz_add(LDict[Length(LDict) - 1].value, LDict[j].value, LDict[idx2].value);
            mpz_mod(LDict[Length(LDict) - 1].value, LDict[Length(LDict) - 1].value, modval);

            If (nextNum - 1 = target) or (nextNum = target) or (nextNum + 1 = target) or (nextNum + 2 = target) Then
                Break;
        End
        Else If divBy = 3 Then
        Begin
            Write('³ ');
            idx := FindL(a);
            If idx < 0 Then
            Begin
                WriteLn('Error: Missing L(a) for tripling at a=', a);
                Halt(1);
            End;
            EnsureLPlusOne(a);
            idx1 := FindL(a + 1);

            AddL(nextNum);
            mpz_mul(temp1, LDict[idx].value, LDict[idx].value);
            If sign = 1 Then
                mpz_sub_ui(temp1, temp1, 3)
            Else
                mpz_add_ui(temp1, temp1, 3);
            mpz_mul(LDict[Length(LDict) - 1].value, LDict[idx].value, temp1);
            mpz_mod(LDict[Length(LDict) - 1].value, LDict[Length(LDict) - 1].value, modval);

            AddL(nextNum + 1);
            mpz_mul(temp1, LDict[idx].value, LDict[idx].value);
            mpz_mul(temp1, temp1, LDict[idx1].value);
            mpz_add(temp2, LDict[idx].value, LDict[idx1].value);
            If sign = 1 Then
                mpz_sub(LDict[Length(LDict) - 1].value, temp1, temp2)
            Else
                mpz_add(LDict[Length(LDict) - 1].value, temp1, temp2);
            mpz_mod(LDict[Length(LDict) - 1].value, LDict[Length(LDict) - 1].value, modval);

            AddL(nextNum + 2);
            j := FindL(nextNum + 1);
            idx2 := FindL(nextNum);
            mpz_add(LDict[Length(LDict) - 1].value, LDict[j].value, LDict[idx2].value);
            mpz_mod(LDict[Length(LDict) - 1].value, LDict[Length(LDict) - 1].value, modval);

            AddL(nextNum - 1);
            j := FindL(nextNum + 1);
            idx2 := FindL(nextNum);
            mpz_sub(LDict[Length(LDict) - 1].value, LDict[j].value, LDict[idx2].value);
            mpz_mod(LDict[Length(LDict) - 1].value, LDict[Length(LDict) - 1].value, modval);

            AddL(nextNum + 3);
            j := FindL(nextNum + 2);
            idx2 := FindL(nextNum + 1);
            mpz_add(LDict[Length(LDict) - 1].value, LDict[j].value, LDict[idx2].value);
            mpz_mod(LDict[Length(LDict) - 1].value, LDict[Length(LDict) - 1].value, modval);

            If (nextNum - 1 = target) or (nextNum = target) or (nextNum + 1 = target) or
               (nextNum + 2 = target) or (nextNum + 3 = target) Then
                Break;
        End;
    End;

    WriteLn;

    idx := FindL(target);
    If idx < 0 Then
    Begin
        WriteLn('Error: Could not compute L(', n, ') mod m');
        Halt(1);
    End;
    mpz_set(result, LDict[idx].value);

    If (n < 0) And ((abs_n Mod 2) = 1) Then
    Begin
        mpz_sub(result, modval, result);
        mpz_mod(result, result, modval);
    End;

    For i := 0 To Length(LDict) - 1 Do
        mpz_clear(LDict[i].value);
    mpz_clear(temp1);
    mpz_clear(temp2);
    mpz_clear(temp3);
    mpz_clear(temp4);

    endTime := Now;
    WriteLn('Hybrid (mod) time: ', MilliSecondsBetween(endTime, startTime), ' ms');
End;

// ============ MODULAR MATRIX for GENERAL P,Q ============
Procedure LucasMatrixModGen(n: Int64; P, Q, modval: mpz_t; Var result: mpz_t);
Var
    Base, ResultMat, TempMat: TMatrix;
    mask: QWord;
    abs_n: QWord;
    startTime, endTime: TDateTime;
    temp1, temp2: mpz_t;
Begin
    startTime := Now;
    mpz_init(temp1);
    mpz_init(temp2);

    InitMatrix(Base, 0, 1, 1, 0);
    mpz_set(Base.a, P);
    mpz_neg(Base.b, Q);
    mpz_set_ui(Base.c, 1);
    mpz_set_ui(Base.d, 0);
    mpz_mod(Base.a, Base.a, modval);
    mpz_mod(Base.b, Base.b, modval);
    mpz_mod(Base.c, Base.c, modval);
    mpz_mod(Base.d, Base.d, modval);

    InitMatrix(ResultMat, 1, 0, 0, 1);
    mpz_mod(ResultMat.a, ResultMat.a, modval);
    mpz_mod(ResultMat.b, ResultMat.b, modval);
    mpz_mod(ResultMat.c, ResultMat.c, modval);
    mpz_mod(ResultMat.d, ResultMat.d, modval);

    InitMatrix(TempMat, 0, 0, 0, 0);

    If n >= 0 Then
        abs_n := QWord(n)
    Else
        abs_n := QWord(-n);

    mask := 1;
    While mask <= abs_n Do
    Begin
        If (abs_n And mask) <> 0 Then
        Begin
            MatrixMul(TempMat, ResultMat, Base);
            mpz_mod(TempMat.a, TempMat.a, modval);
            mpz_mod(TempMat.b, TempMat.b, modval);
            mpz_mod(TempMat.c, TempMat.c, modval);
            mpz_mod(TempMat.d, TempMat.d, modval);
            mpz_set(ResultMat.a, TempMat.a);
            mpz_set(ResultMat.b, TempMat.b);
            mpz_set(ResultMat.c, TempMat.c);
            mpz_set(ResultMat.d, TempMat.d);
        End;
        MatrixMul(TempMat, Base, Base);
        mpz_mod(TempMat.a, TempMat.a, modval);
        mpz_mod(TempMat.b, TempMat.b, modval);
        mpz_mod(TempMat.c, TempMat.c, modval);
        mpz_mod(TempMat.d, TempMat.d, modval);
        mpz_set(Base.a, TempMat.a);
        mpz_set(Base.b, TempMat.b);
        mpz_set(Base.c, TempMat.c);
        mpz_set(Base.d, TempMat.d);
        mask := mask Shl 1;
    End;

    // V_n = ResultMat.c * V_1 + ResultMat.d * V_0
    mpz_mul(temp1, ResultMat.c, P);
    mpz_mul_ui(temp2, ResultMat.d, 2);
    mpz_add(temp1, temp1, temp2);
    mpz_mod(result, temp1, modval);

    ClearMatrix(Base);
    ClearMatrix(ResultMat);
    ClearMatrix(TempMat);
    mpz_clear(temp1);
    mpz_clear(temp2);

    endTime := Now;
    WriteLn('Matrix (mod) time: ', MilliSecondsBetween(endTime, startTime), ' ms');
End;

// ============ MODULAR FAST DOUBLING for GENERAL P,Q ============
Procedure FastDoublingIterativeVMod(n: QWord; P, Q, modval: mpz_t; Var Vn: mpz_t);
Var
    Vk, Vk1, Qk: mpz_t;
    mask, k: QWord;
    temp1, temp2, temp3: mpz_t;
Begin
    mpz_init(Vk); mpz_init(Vk1); mpz_init(Qk);
    mpz_init(temp1); mpz_init(temp2); mpz_init(temp3);

    mpz_set_ui(Vk, 2);
    mpz_set(Vk1, P);
    mpz_set_ui(Qk, 1);

    mask := 1;
    While mask <= n Do
        mask := mask Shl 1;
    mask := mask Shr 1;

    k := 0;
    While mask > 0 Do
    Begin
        // V(2k), V(2k+1)
        mpz_mul(temp1, Vk, Vk);
        mpz_mul_ui(temp2, Qk, 2);
        mpz_sub(temp1, temp1, temp2);
        mpz_mod(temp1, temp1, modval);   // V(2k)

        mpz_mul(temp2, Vk, Vk1);
        mpz_mul(temp3, P, Qk);
        mpz_sub(temp2, temp2, temp3);
        mpz_mod(temp2, temp2, modval);   // V(2k+1)

        // V(2k+2)
        mpz_mul(temp3, P, temp2);
        mpz_mul(Vk1, Q, temp1);          // reuse Vk1 as temp
        mpz_sub(temp3, temp3, Vk1);
        mpz_mod(temp3, temp3, modval);

        // Q(2k)
        mpz_mul(Qk, Qk, Qk);
        mpz_mod(Qk, Qk, modval);

        If (n And mask) <> 0 Then
        Begin
            mpz_set(Vk, temp2);          // V(2k+1)
            mpz_set(Vk1, temp3);         // V(2k+2)
            mpz_mul(Qk, Qk, Q);
            mpz_mod(Qk, Qk, modval);
            k := 2*k + 1;
        End
        Else
        Begin
            mpz_set(Vk, temp1);          // V(2k)
            mpz_set(Vk1, temp2);         // V(2k+1)
            k := 2*k;
        End;
        mask := mask Shr 1;
    End;

    mpz_set(Vn, Vk);

    mpz_clear(Vk); mpz_clear(Vk1); mpz_clear(Qk);
    mpz_clear(temp1); mpz_clear(temp2); mpz_clear(temp3);
End;

Procedure LucasFastDoublingModGen(n: Int64; P, Q, modval: mpz_t; Var result: mpz_t);
Var
    startTime, endTime: TDateTime;
    fn: mpz_t;
    abs_n: QWord;
Begin
    startTime := Now;
    If n >= 0 Then
        abs_n := QWord(n)
    Else
        abs_n := QWord(-n);

    mpz_init(fn);
    FastDoublingIterativeVMod(abs_n, P, Q, modval, fn);

    If n < 0 Then
    Begin
        If (abs_n Mod 2) = 1 Then
        Begin
            mpz_sub(fn, modval, fn);
            mpz_mod(fn, fn, modval);
        End;
    End;

    mpz_set(result, fn);
    mpz_clear(fn);
    endTime := Now;
    WriteLn('Fast doubling (mod) time: ', MilliSecondsBetween(endTime, startTime), ' ms');
End;

// ============ MODULAR MATRIX for DEFAULT (unchanged) ============
Procedure LucasMatrixMod(n: Int64; Var result: mpz_t; modval: mpz_t);
Var
    Base, ResultMat, TempMat: TMatrix;
    mask: QWord;
    abs_n: QWord;
    startTime, endTime: TDateTime;
    temp1, temp2: mpz_t;
Begin
    startTime := Now;
    mpz_init(temp1);
    mpz_init(temp2);

    InitMatrix(Base, 0, 1, 1, 1);
    mpz_mod(Base.a, Base.a, modval);
    mpz_mod(Base.b, Base.b, modval);
    mpz_mod(Base.c, Base.c, modval);
    mpz_mod(Base.d, Base.d, modval);

    InitMatrix(ResultMat, 1, 0, 0, 1);
    mpz_mod(ResultMat.a, ResultMat.a, modval);
    mpz_mod(ResultMat.b, ResultMat.b, modval);
    mpz_mod(ResultMat.c, ResultMat.c, modval);
    mpz_mod(ResultMat.d, ResultMat.d, modval);

    InitMatrix(TempMat, 0, 0, 0, 0);

    If n >= 0 Then
        abs_n := QWord(n)
    Else
        abs_n := QWord(-n);

    mask := 1;
    While mask <= abs_n Do
    Begin
        If (abs_n And mask) <> 0 Then
        Begin
            MatrixMul(TempMat, ResultMat, Base);
            mpz_mod(TempMat.a, TempMat.a, modval);
            mpz_mod(TempMat.b, TempMat.b, modval);
            mpz_mod(TempMat.c, TempMat.c, modval);
            mpz_mod(TempMat.d, TempMat.d, modval);
            mpz_set(ResultMat.a, TempMat.a);
            mpz_set(ResultMat.b, TempMat.b);
            mpz_set(ResultMat.c, TempMat.c);
            mpz_set(ResultMat.d, TempMat.d);
        End;
        MatrixMul(TempMat, Base, Base);
        mpz_mod(TempMat.a, TempMat.a, modval);
        mpz_mod(TempMat.b, TempMat.b, modval);
        mpz_mod(TempMat.c, TempMat.c, modval);
        mpz_mod(TempMat.d, TempMat.d, modval);
        mpz_set(Base.a, TempMat.a);
        mpz_set(Base.b, TempMat.b);
        mpz_set(Base.c, TempMat.c);
        mpz_set(Base.d, TempMat.d);
        mask := mask Shl 1;
    End;

    mpz_mul_ui(temp1, ResultMat.a, 2);
    mpz_add(temp1, temp1, ResultMat.b);
    mpz_mod(result, temp1, modval);

    ClearMatrix(Base);
    ClearMatrix(ResultMat);
    ClearMatrix(TempMat);
    mpz_clear(temp1);
    mpz_clear(temp2);

    endTime := Now;
    WriteLn('Matrix (mod) time: ', MilliSecondsBetween(endTime, startTime), ' ms');
End;

// ============ MODULAR FAST DOUBLING for DEFAULT ============
Procedure FastDoublingIterativeLucasMod(n: QWord; Var result: mpz_t; modval: mpz_t);
Var
    a, b, c, d, temp: mpz_t;
    mask: QWord;
    k: QWord;
    sign: Integer;
Begin
    mpz_init_set_ui(a, 2);
    mpz_mod(a, a, modval);
    mpz_init_set_ui(b, 1);
    mpz_mod(b, b, modval);
    mpz_init(c);
    mpz_init(d);
    mpz_init(temp);

    mask := 1;
    While mask <= n Do
        mask := mask Shl 1;
    mask := mask Shr 1;

    k := 0;
    While mask > 0 Do
    Begin
        If (k Mod 2) = 0 Then sign := 1 Else sign := -1;

        mpz_mul(temp, a, a);
        mpz_mod(temp, temp, modval);
        If sign = 1 Then
            mpz_sub_ui(c, temp, 2)
        Else
            mpz_add_ui(c, temp, 2);
        mpz_mod(c, c, modval);

        mpz_mul(temp, a, b);
        mpz_mod(temp, temp, modval);
        If sign = 1 Then
            mpz_sub_ui(d, temp, 1)
        Else
            mpz_add_ui(d, temp, 1);
        mpz_mod(d, d, modval);

        If (n And mask) <> 0 Then
        Begin
            mpz_set(a, d);
            mpz_add(temp, d, c);
            mpz_mod(b, temp, modval);
            k := 2*k + 1;
        End
        Else
        Begin
            mpz_set(a, c);
            mpz_set(b, d);
            k := 2*k;
        End;
        mask := mask Shr 1;
    End;

    mpz_set(result, a);

    mpz_clear(a);
    mpz_clear(b);
    mpz_clear(c);
    mpz_clear(d);
    mpz_clear(temp);
End;

Procedure LucasFastDoublingMod(n: Int64; Var result: mpz_t; modval: mpz_t);
Var
    startTime, endTime: TDateTime;
    fn: mpz_t;
    abs_n: QWord;
Begin
    startTime := Now;
    If n >= 0 Then
        abs_n := QWord(n)
    Else
        abs_n := QWord(-n);

    mpz_init(fn);
    FastDoublingIterativeLucasMod(abs_n, fn, modval);

    If n < 0 Then
    Begin
        If (abs_n Mod 2) = 1 Then
        Begin
            mpz_sub(fn, modval, fn);
            mpz_mod(fn, fn, modval);
        End;
    End;

    mpz_set(result, fn);
    mpz_clear(fn);
    endTime := Now;
    WriteLn('Fast doubling (mod) time: ', MilliSecondsBetween(endTime, startTime), ' ms');
End;

// ============ WRAPPER for MODULAR COMPUTATION ============
Procedure ComputeVMod(n: Int64; P, Q, modval: mpz_t; Var result: mpz_t; alg: TAlgorithm);
Begin
    Case alg Of
        algMatrix:
            LucasMatrixModGen(n, P, Q, modval, result);
        algFastDoubling:
            LucasFastDoublingModGen(n, P, Q, modval, result);
        algHybrid:
            // Hybrid only for P=1, Q=-1
            If (mpz_cmp_ui(P,1)=0) and (mpz_cmp_si(Q,-1)=0) Then
                LucasHybridMod(n, result, modval)
            Else
                LucasFastDoublingModGen(n, P, Q, modval, result);
        Else
            LucasFastDoublingModGen(n, P, Q, modval, result);
    End;
End;

// Fast reduction for M_p = 2^p - 1
// Assumes x is the result of s^2, and p is the exponent.
Procedure ReduceModMersenne(Var x: mpz_t; p: Integer);
Var
    mask: mpz_t;
    shift: mpz_t;
    high, low: mpz_t;
Begin
    mpz_init(mask);
    mpz_init(shift);
    mpz_init(high);
    mpz_init(low);

    // mask = 2^p - 1
    mpz_set_ui(mask, 1);
    mpz_mul_2exp(mask, mask, p);
    mpz_sub_ui(mask, mask, 1);

    // shift = x >> p
    mpz_fdiv_q_2exp(shift, x, p);

    // low = x & mask
    mpz_and(low, x, mask);

    // x = low + shift
    mpz_add(x, low, shift);

    // If x >= M_p, subtract M_p (usually once is enough, but loop to be safe)
    While mpz_cmp(x, mask) >= 0 Do
        mpz_sub(x, x, mask);

    mpz_clear(mask);
    mpz_clear(shift);
    mpz_clear(high);
    mpz_clear(low);
End;

// ============ LUCAS‑LEHMER TEST (CORRECTED) ============
Procedure LucasLehmerTest(p: Integer);
Var
    M, s: mpz_t;
    i: Integer;
    startTime, endTime: TDateTime;
    isPrime: Boolean;
Begin
    If p < 2 Then
    Begin
        WriteLn('p must be >= 2');
        Exit;
    End;
    WriteLn('========================================');
    WriteLn('Lucas‑Lehmer test for M_', p, ' = 2^', p, ' - 1');
    WriteLn('========================================');

    startTime := Now;
    mpz_init(M);
    mpz_init(s);

    // M = 2^p - 1
    mpz_set_ui(M, 1);
    mpz_mul_2exp(M, M, p);
    mpz_sub_ui(M, M, 1);
    WriteLn('M_', p, ' has ', mpz_sizeinbase(M, 10), ' decimal digits');

    If p = 2 Then
        isPrime := True
    Else
    Begin
        mpz_set_ui(s, 4);                // s_0 = 4
        For i := 1 To p - 2 Do
        Begin
            mpz_mul(s, s, s);            // s = s^2
            mpz_sub_ui(s, s, 2);         // s = s - 2
            ReduceModMersenne(s, p);   // instead of mpz_mod(s, s, M);
        End;
        isPrime := (mpz_cmp_ui(s, 0) = 0);
    End;

    endTime := Now;
    If isPrime Then
        WriteLn('M_', p, ' is PRIME.')
    Else
        WriteLn('M_', p, ' is COMPOSITE (or not proven).');
    WriteLn('Time: ', MilliSecondsBetween(endTime, startTime), ' ms');

    mpz_clear(M);
    mpz_clear(s);
    WriteLn;
End;

// ============ DISPLAY FUNCTIONS ============
Procedure DisplayLargeLucas(n: Int64; Var val: mpz_t);
Var
    s: AnsiString;
    len: Integer;
    first20, last20: AnsiString;
Begin
    s := mpz_get_str(Nil, 10, val);
    len := Length(Trim(s));
    WriteLn('L(', n, ') has ', len, ' digits');
    If len <= 40 Then
        WriteLn('L(', n, ') = ', s)
    Else
    Begin
        first20 := Copy(s, 1, 20);
        last20 := Copy(s, len - 19, 20);
        WriteLn('First 20 digits: ', Trim(first20));
        WriteLn('Last 20 digits:  ', Trim(last20));
    End;
    WriteLn;
End;

Procedure DisplayResidue(n: Int64; Var val: mpz_t; modval: mpz_t);
Var
    s: AnsiString;
Begin
    s := mpz_get_str(Nil, 10, val);
    WriteLn('V_', n, '(', mpz_get_str(Nil,10,Pparam), ',', mpz_get_str(Nil,10,Qparam), ') mod m = ', s);
    WriteLn;
End;

// ============ BENCHMARK (integer) ============
Procedure BenchmarkLucasMethods(n: Int64);
Var
    r1, r2, r3, r4: mpz_t;
    s1, s2, s3, s4: AnsiString;
    startTime, endTime: TDateTime;
Begin
    WriteLn('========================================');
    WriteLn('Benchmarking L(', n, ')');
    WriteLn('========================================');

    mpz_init(r1);
    mpz_init(r2);
    mpz_init(r3);
    mpz_init(r4);

    WriteLn;
    WriteLn('1. Matrix Exponentiation:');
    startTime := Now;
    LucasMatrix(n, r1);
    endTime := Now;
    s1 := mpz_get_str(Nil, 10, r1);
    WriteLn('Result length: ', Length(s1), ' digits');
    WriteLn('Total time: ', MilliSecondsBetween(endTime, startTime), ' ms');

    WriteLn;
    WriteLn('2. Fast Doubling:');
    startTime := Now;
    LucasFastDoubling(n, r2);
    endTime := Now;
    s2 := mpz_get_str(Nil, 10, r2);
    WriteLn('Result length: ', Length(s2), ' digits');
    WriteLn('Total time: ', MilliSecondsBetween(endTime, startTime), ' ms');

    WriteLn;
    WriteLn('3. Hybrid (Greedy Descent):');
    startTime := Now;
    LucasHybrid(n, r3);
    endTime := Now;
    s3 := mpz_get_str(Nil, 10, r3);
    WriteLn('Result length: ', Length(s3), ' digits');
    WriteLn('Total time: ', MilliSecondsBetween(endTime, startTime), ' ms');

    If mpz_cmp(r1, r2) = 0 Then
        WriteLn('✓ Matrix and Doubling match')
    Else
        WriteLn('✗ Matrix and Doubling differ!');
    If mpz_cmp(r2, r3) = 0 Then
        WriteLn('✓ Doubling and Hybrid match')
    Else
        WriteLn('✗ Doubling and Hybrid differ!');

    If (n >= Low(Integer)) and (n <= High(Integer)) and (Abs(n) <= 100000) Then
    Begin
        WriteLn;
        WriteLn('4. Iterative Method:');
        startTime := Now;
        LucasIterative(Integer(n), r4);
        endTime := Now;
        s4 := mpz_get_str(Nil, 10, r4);
        WriteLn('Result length: ', Length(s4), ' digits');
        WriteLn('Total time: ', MilliSecondsBetween(endTime, startTime), ' ms');
        If mpz_cmp(r1, r4) = 0 Then
            WriteLn('✓ Iterative matches')
        Else
            WriteLn('✗ Iterative differs!');
    End
    Else
    Begin
        WriteLn;
        WriteLn('4. Iterative: Skipped (n too large)');
    End;

    mpz_clear(r1);
    mpz_clear(r2);
    mpz_clear(r3);
    mpz_clear(r4);
    WriteLn;
End;

// ============ BENCHMARK (modular general) ============
Procedure BenchmarkLucasMethodsModGen(n: Int64; P, Q, modval: mpz_t);
Var
    r1, r2, r3: mpz_t;
    s1, s2, s3: AnsiString;
    startTime, endTime: TDateTime;
    ok: boolean;
Begin
    WriteLn('========================================');
    WriteLn('Benchmarking V_', n, '(', mpz_get_str(Nil,10,P), ',', mpz_get_str(Nil,10,Q), ') mod m (m = ', mpz_get_str(Nil,10,modval), ')');
    WriteLn('========================================');

    mpz_init(r1);
    mpz_init(r2);
    mpz_init(r3);

    WriteLn;
    WriteLn('1. Matrix (mod):');
    startTime := Now;
    LucasMatrixModGen(n, P, Q, modval, r1);
    endTime := Now;
    s1 := mpz_get_str(Nil, 10, r1);
    WriteLn('Result length: ', Length(s1), ' digits');
    WriteLn('Total time: ', MilliSecondsBetween(endTime, startTime), ' ms');

    WriteLn;
    WriteLn('2. Fast Doubling (mod):');
    startTime := Now;
    LucasFastDoublingModGen(n, P, Q, modval, r2);
    endTime := Now;
    s2 := mpz_get_str(Nil, 10, r2);
    WriteLn('Result length: ', Length(s2), ' digits');
    WriteLn('Total time: ', MilliSecondsBetween(endTime, startTime), ' ms');

    WriteLn;
    WriteLn('3. Hybrid (mod):');
    startTime := Now;
    // Hybrid only for P=1,Q=-1
    If (mpz_cmp_ui(P,1)=0) and (mpz_cmp_si(Q,-1)=0) Then
        LucasHybridMod(n, r3, modval)
    Else
    Begin
        WriteLn('(fallback to fast doubling for non‑default P,Q)');
        LucasFastDoublingModGen(n, P, Q, modval, r3);
    End;
    endTime := Now;
    s3 := mpz_get_str(Nil, 10, r3);
    WriteLn('Result length: ', Length(s3), ' digits');
    WriteLn('Total time: ', MilliSecondsBetween(endTime, startTime), ' ms');

    ok := True;
    If mpz_cmp(r1, r2) <> 0 Then
    Begin
        WriteLn('✗ Matrix and Doubling differ!');
        ok := False;
    End
    Else
        WriteLn('✓ Matrix and Doubling match');

    If mpz_cmp(r2, r3) <> 0 Then
    Begin
        WriteLn('✗ Doubling and Hybrid differ!');
        ok := False;
    End
    Else
        WriteLn('✓ Doubling and Hybrid match');

    If ok Then
        WriteLn('All tests passed.')
    Else
        WriteLn('WARNING: Some tests failed.');

    mpz_clear(r1);
    mpz_clear(r2);
    mpz_clear(r3);
    WriteLn;
End;

// ============ COMMAND LINE PARSING ============
Var
    lucas_gmp: mpz_t;
    n: Int64;
    i: Integer;
    algorithm: TAlgorithm;
    benchmarkMode: Boolean;
    modStr: String;
    Pstr, Qstr: String;

Function ParseAlgorithm(Str: String): TAlgorithm;
Var lowerStr: String;
Begin
    lowerStr := LowerCase(Str);
    If lowerStr = 'matrix' Then Result := algMatrix
    Else If lowerStr = 'fastdoubling' Then Result := algFastDoubling
    Else If lowerStr = 'iterative' Then Result := algIterative
    Else If lowerStr = 'hybrid' Then Result := algHybrid
    Else Raise EConvertError.Create('Invalid algorithm: ' + Str);
End;

Procedure DemoMode;
const
  exponents: array[0..29] of longint = (
    2, 3, 5, 7, 13, 17, 19, 31, 61, 89, 107, 127, 521, 607, 1279,
    2203, 2281, 3217, 4253, 4423, 9689, 9941, 11213, 19937, 21701,
    23209, 44497, 86243, 110503, 132049
  );

var
  i: integer;
    Begin
        // Demo
        WriteLn;
        WriteLn('===========================================================');
        WriteLn('Fast Lucas Calculator – Generalised P,Q + Lucas‑Lehmer Demo');
        WriteLn('===========================================================');
        WriteLn;
        WriteLn('Default sequence L(n) = V_n(1,-1):');
        LucasHybrid(30, lucas_gmp);
        WriteLn('L(30) = ', mpz_get_str(Nil, 10, lucas_gmp));
        WriteLn;

        WriteLn('Lucas‑Lehmer test for small Mersenne numbers:');

        for i := Low(exponents) to High(exponents) do
            LucasLehmerTest(exponents[i]);

        WriteLn;

        WriteLn('Usage examples:');
        WriteLn('  ./' + Fname + ' 1000 -m=1000000007            # L(1000) mod p');
        WriteLn('  ./' + Fname + ' 1000 -P=3 -Q=2 -m=123456789   # V_1000(3,2) mod m');
        WriteLn('  ./' + Fname + ' -lucaslehmer=13               # Test M_13');
        WriteLn('  ./' + Fname + ' -lucaslehmer=31               # Test M_31');
        WriteLn('  ./' + Fname + ' -lucaslehmer=11213            # Test M_11213');
        WriteLn('  ./' + Fname + ' 1000000 -benchmark            # Benchmark integer');
        WriteLn('  ./' + Fname + ' 1000000 -m=1000000007 -benchmark  # Benchmark modular');
        WriteLn;
    End;

Begin
    mpz_init(lucas_gmp);
    mpz_init(Modulus);
    mpz_init(Pparam);
    mpz_init(Qparam);
    mpz_set_ui(Pparam, 1);
    mpz_set_si(Qparam, -1);

    UseModulus := False;
    benchmarkMode := False;
    LucasLehmerMode := False;
    algorithm := algHybrid;

    If ParamCount >= 1 Then
    Begin
        Try
            // Check for -lucaslehmer flag first
            For i := 1 To ParamCount Do
                If Pos('-lucaslehmer=', LowerCase(ParamStr(i))) = 1 Then
                Begin
                    LL_exponent := StrToInt(Trim(Copy(ParamStr(i), 14, MaxInt)));
                    LucasLehmerMode := True;
                    mpz_set_ui(Pparam, 4);
                    mpz_set_ui(Qparam, 1);
                    Break;
                End;

            If Not LucasLehmerMode Then
                n := StrToInt64(ParamStr(1));

            For i := 2 To ParamCount Do
            Begin
                If LowerCase(ParamStr(i)) = '-benchmark' Then
                    benchmarkMode := True
                Else If Pos('-a=', LowerCase(ParamStr(i))) = 1 Then
                Begin
                    Try
                        algorithm := ParseAlgorithm(Trim(Copy(ParamStr(i), 4, MaxInt)));
                    Except
                        On E: EConvertError Do
                            WriteLn('Warning: ', E.Message, ' Using default: hybrid');
                    End;
                End
                Else If Pos('-m=', LowerCase(ParamStr(i))) = 1 Then
                Begin
                    modStr := Trim(Copy(ParamStr(i), 4, MaxInt));
                    If mpz_set_str(Modulus, PChar(modStr), 0) <> 0 Then
                    Begin
                        WriteLn('Error: Invalid modulus string: ', modStr);
                        Halt(1);
                    End;
                    If mpz_cmp_ui(Modulus, 0) <= 0 Then
                    Begin
                        WriteLn('Error: Modulus must be positive.');
                        Halt(1);
                    End;
                    UseModulus := True;
                End
                Else If Pos('-P=', LowerCase(ParamStr(i))) = 1 Then
                Begin
                    Pstr := Trim(Copy(ParamStr(i), 4, MaxInt));
                    If mpz_set_str(Pparam, PChar(Pstr), 0) <> 0 Then
                    Begin
                        WriteLn('Error: Invalid P value: ', Pstr);
                        Halt(1);
                    End;
                End
                Else If Pos('-Q=', LowerCase(ParamStr(i))) = 1 Then
                Begin
                    Qstr := Trim(Copy(ParamStr(i), 4, MaxInt));
                    If mpz_set_str(Qparam, PChar(Qstr), 0) <> 0 Then
                    Begin
                        WriteLn('Error: Invalid Q value: ', Qstr);
                        Halt(1);
                    End;
                End;
            End;

            If LucasLehmerMode Then
                LucasLehmerTest(LL_exponent)
            Else If UseModulus Then
            Begin
                If benchmarkMode Then
                    BenchmarkLucasMethodsModGen(n, Pparam, Qparam, Modulus)
                Else
                Begin
                    WriteLn('Computing V_', n, '(', mpz_get_str(Nil,10,Pparam), ',', mpz_get_str(Nil,10,Qparam), ') mod m...');
                    ComputeVMod(n, Pparam, Qparam, Modulus, lucas_gmp, algorithm);
                    DisplayResidue(n, lucas_gmp, Modulus);
                End;
            End
            Else
            Begin
                // Integer mode – only allowed for P=1,Q=-1
                If (mpz_cmp_ui(Pparam,1)<>0) or (mpz_cmp_si(Qparam,-1)<>0) Then
                Begin
                    WriteLn('Error: Integer computation only supported for default P=1, Q=-1.');
                    WriteLn('Please use modular mode (-m=<mod>) for other parameters.');
                    Halt(1);
                End;
                If benchmarkMode Then
                    BenchmarkLucasMethods(n)
                Else
                Begin
                    Case algorithm Of
                        algMatrix:
                        Begin
                            WriteLn('Computing L(', n, ') using matrix exponentiation...');
                            LucasMatrix(n, lucas_gmp);
                        End;
                        algFastDoubling:
                        Begin
                            WriteLn('Computing L(', n, ') using fast doubling...');
                            LucasFastDoubling(n, lucas_gmp);
                        End;
                        algIterative:
                        Begin
                            If (n < Low(Integer)) Or (n > High(Integer)) Then
                            Begin
                                WriteLn('Error: Iterative method only supports n between ', Low(Integer), ' and ', High(Integer));
                                Halt(1);
                            End;
                            WriteLn('Computing L(', n, ') using iterative method...');
                            LucasIterative(Integer(n), lucas_gmp);
                        End;
                        algHybrid:
                        Begin
                            WriteLn('Computing L(', n, ') using hybrid (doubling/tripling) method...');
                            LucasHybrid(n, lucas_gmp);
                        End;
                    End;
                    DisplayLargeLucas(n, lucas_gmp);
                End;
            End;

        Except
            On E: Exception Do
                WriteLn('Error: ', E.Message);
        End;
    End
    Else
       Demomode;

    mpz_clear(lucas_gmp);
    mpz_clear(Modulus);
    mpz_clear(Pparam);
    mpz_clear(Qparam);
    WriteLn('Program completed.');
End.
