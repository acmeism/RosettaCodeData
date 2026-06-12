Program FastFibonacciGMP;
{$mode objfpc}{$H+}{$J-}

// ============================================================================
// Fast Fibonacci Calculator with Multiple Algorithms and GMP
// ----------------------------------------------------------------------------
// 2025.12.05
// Author: jpd
// AI Assistant: DeepSeek
// Description: Multiple Fibonacci algorithms with arbitrary precision
//              AI translated from my own 2016 python app ( the hybrid part )
// License: Public Domain for Rosetta Code contribution
// ============================================================================

Uses
    SysUtils,
    DateUtils,
    Gmp;

// ----------------------------------------------------------------------------
// Matrix type for 2x2 integer matrix using GMP arbitrary precision
// ----------------------------------------------------------------------------
Type
    TMatrix = Record
        a, b, c, d: mpz_t;
    End;

    // Enum for algorithm selection
    TAlgorithm = (algMatrix, algFastDoubling, algIterative, algHybrid);

// ----------------------------------------------------------------------------
// Initialize matrix with four integer values
// ----------------------------------------------------------------------------
Procedure InitMatrix(Var m: TMatrix; a, b, c, d: Integer);
Begin
    mpz_init_set_si(m.a, a);
    mpz_init_set_si(m.b, b);
    mpz_init_set_si(m.c, c);
    mpz_init_set_si(m.d, d);
End;

// ----------------------------------------------------------------------------
// Clear GMP memory for matrix elements
// ----------------------------------------------------------------------------
Procedure ClearMatrix(Var m: TMatrix);
Begin
    mpz_clear(m.a);
    mpz_clear(m.b);
    mpz_clear(m.c);
    mpz_clear(m.d);
End;

// ----------------------------------------------------------------------------
// Multiply two matrices: R = A × B
// Uses GMP for arbitrary precision arithmetic
// ----------------------------------------------------------------------------
Procedure MatrixMul(Var R, A, B: TMatrix);
Var
    temp1, temp2, temp3, temp4: mpz_t;
Begin
    // Initialize temporaries
    mpz_init(temp1);
    mpz_init(temp2);
    mpz_init(temp3);
    mpz_init(temp4);

    // temp1 = A.a × B.a + A.b × B.c
    mpz_mul(temp1, A.a, B.a);
    mpz_mul(temp2, A.b, B.c);
    mpz_add(temp1, temp1, temp2);

    // temp2 = A.a × B.b + A.b × B.d
    mpz_mul(temp2, A.a, B.b);
    mpz_mul(temp3, A.b, B.d);
    mpz_add(temp2, temp2, temp3);

    // temp3 = A.c × B.a + A.d × B.c
    mpz_mul(temp3, A.c, B.a);
    mpz_mul(temp4, A.d, B.c);
    mpz_add(temp3, temp3, temp4);

    // temp4 = A.c × B.b + A.d × B.d
    mpz_mul(temp4, A.c, B.b);
    mpz_mul(R.d, A.d, B.d);  // Reuse R.d as temp
    mpz_add(temp4, temp4, R.d);

    // Store results
    mpz_set(R.a, temp1);
    mpz_set(R.b, temp2);
    mpz_set(R.c, temp3);
    mpz_set(R.d, temp4);

    // Cleanup temporaries
    mpz_clear(temp1);
    mpz_clear(temp2);
    mpz_clear(temp3);
    mpz_clear(temp4);
End;

// ----------------------------------------------------------------------------
// Compute Fibonacci number F(n) using matrix exponentiation
// Supports both positive and negative indices using 64-bit integers
// ----------------------------------------------------------------------------
Procedure FibonacciMatrix(n: Int64; Var result: mpz_t);
Var
    Base, ResultMat, TempMat: TMatrix;
    mask: QWord;
    abs_n: QWord;
    startTime, endTime: TDateTime;
Begin
    startTime := Now;

    // Initialize matrices
    If n >= 0 Then
        InitMatrix(Base, 0, 1, 1, 1)      // [0 1; 1 1] for positive n
    Else
        InitMatrix(Base, -1, 1, 1, 0);    // [-1 1; 1 0] for negative n

    // Identity matrix for exponentiation
    InitMatrix(ResultMat, 1, 0, 0, 1);
    InitMatrix(TempMat, 0, 0, 0, 0);

    // Use absolute value for exponentiation
    If n >= 0 Then
        abs_n := QWord(n)
    Else
        abs_n := QWord(-n);

    mask := 1;

    // Fast exponentiation by squaring: O(log n) complexity
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

        // Square the base matrix
        MatrixMul(TempMat, Base, Base);
        mpz_set(Base.a, TempMat.a);
        mpz_set(Base.b, TempMat.b);
        mpz_set(Base.c, TempMat.c);
        mpz_set(Base.d, TempMat.d);

        mask := mask Shl 1;
    End;

    // Result is in the (0,1) position of the matrix
    mpz_set(result, ResultMat.b);

    // Cleanup
    ClearMatrix(Base);
    ClearMatrix(ResultMat);
    ClearMatrix(TempMat);

    endTime := Now;
    WriteLn('Matrix method time: ', MilliSecondsBetween(endTime, startTime), ' ms');
End;

// ----------------------------------------------------------------------------
// Iterative version of Fast Doubling (avoids recursion depth issues)*
//
// Process bits of n from most significant to least significant
// ----------------------------------------------------------------------------
Procedure FastDoublingIterative(n: QWord; Var result: mpz_t);
Var
    a, b, c, d, temp1, temp2: mpz_t;
    mask: QWord;
Begin
    // Initialize GMP variables
    mpz_init_set_ui(a, 0);  // F(0) = 0
    mpz_init_set_ui(b, 1);  // F(1) = 1
    mpz_init(c);
    mpz_init(d);
    mpz_init(temp1);
    mpz_init(temp2);

    // Find highest set bit
    mask := 1;
    While mask <= n Do
        mask := mask Shl 1;
    mask := mask Shr 1;  // Now mask is the highest set bit

    // Process bits from most significant to least significant
    While mask > 0 Do
    Begin
        // c = F(2k) = F(k) * [2 * F(k+1) - F(k)]
        // where k = current value of a,b (representing F(k), F(k+1))

        // Calculate 2*b - a
        mpz_mul_ui(temp1, b, 2);    // 2 * F(k+1)
        mpz_sub(temp1, temp1, a);   // 2 * F(k+1) - F(k)

        // c = a * (2*b - a)
        mpz_mul(c, a, temp1);

        // d = F(k+1)² + F(k)²
        mpz_mul(temp1, b, b);       // b²
        mpz_mul(temp2, a, a);       // a²
        mpz_add(d, temp1, temp2);   // a² + b²

        // Update a, b based on current bit of n
        If (n And mask) <> 0 Then
        Begin
            // Current bit is 1: (a,b) = (d, c+d)
            // This corresponds to going from (F(k), F(k+1)) to (F(2k+1), F(2k+2))
            mpz_add(temp1, c, d);   // c + d = F(2k+1) + F(2k) = F(2k+2)
            mpz_set(a, d);          // a = F(2k+1)
            mpz_set(b, temp1);      // b = F(2k+2)
        End
        Else
        Begin
            // Current bit is 0: (a,b) = (c, d)
            // This corresponds to going from (F(k), F(k+1)) to (F(2k), F(2k+1))
            mpz_set(a, c);          // a = F(2k)
            mpz_set(b, d);          // b = F(2k+1)
        End;

        mask := mask Shr 1;
    End;

    // Result is in a
    mpz_set(result, a);

    // Cleanup
    mpz_clear(a);
    mpz_clear(b);
    mpz_clear(c);
    mpz_clear(d);
    mpz_clear(temp1);
    mpz_clear(temp2);
End;

// ----------------------------------------------------------------------------
// Wrapper for Fast Doubling with timing
// ----------------------------------------------------------------------------
Procedure FibonacciFastDoubling(n: Int64; Var result: mpz_t);
Var
    startTime, endTime: TDateTime;
    fn: mpz_t;
    abs_n: QWord;
Begin
    startTime := Now;

    // Handle negative n using F(-n) = (-1)^(n+1) * F(n)
    If n >= 0 Then
        abs_n := QWord(n)
    Else
        abs_n := QWord(-n);

    mpz_init(fn);
    FastDoublingIterative(abs_n, fn);

    If n < 0 Then
    Begin
        // Apply sign for negative indices
        If (abs_n Mod 2) = 0 Then
            mpz_neg(fn, fn);
    End;

    mpz_set(result, fn);
    mpz_clear(fn);

    endTime := Now;
    WriteLn('Fast doubling method time: ', MilliSecondsBetween(endTime, startTime), ' ms');
End;

// ----------------------------------------------------------------------------
// Hybrid Doubling/Tripling Method (Fastest and most efficient)
// Based on Python matfib.1.1.py algorithm with corrected logic*
// ----------------------------------------------------------------------------
Procedure FibonacciHybrid(n: Int64; Var result: mpz_t);
Var
    startTime, endTime: TDateTime;
    FDict: array of record
        key: QWord;
        value: mpz_t;
    end;
    DivMap: array of record
        key: QWord;
        divisor: QWord;
    end;
    i, j, idx: Integer;
    a, divBy, nextNum: QWord;
    temp1, temp2, temp3: mpz_t;
    sign: Boolean;
    abs_n: QWord;
    target: QWord;
    sortedKeys: array of QWord;

    // Find index of key in FDict array
    Function FindF(key: QWord): Integer;
    Var
        i: Integer;
    Begin
        For i := 0 To Length(FDict) - 1 Do
            If FDict[i].key = key Then
            Begin
                Result := i;
                Exit;
            End;
        Result := -1;
    End;

    // Add new Fibonacci number to FDict array
    Procedure AddF(key: QWord);
    Begin
        SetLength(FDict, Length(FDict) + 1);
        FDict[Length(FDict) - 1].key := key;
        mpz_init(FDict[Length(FDict) - 1].value);
    End;

    // Helper: Compute F(n+1) if not already in dictionary*
    Procedure EnsureFPlusOne(n: QWord);
    Var
        idx1, idx2: Integer;
    Begin
        If FindF(n + 1) >= 0 Then
            Exit;

        // Compute F(n+1) = F(n) + F(n-1)
        idx1 := FindF(n);
        idx2 := FindF(n - 1);

        If (idx1 < 0) or (idx2 < 0) Then
        Begin
            WriteLn('Error: Cannot compute F(', n+1, ')');
            Halt(1);
        End;

        AddF(n + 1);
        mpz_add(FDict[Length(FDict) - 1].value, FDict[idx1].value, FDict[idx2].value);
    End;

Begin
    startTime := Now;

    // Initialize GMP temporaries
    mpz_init(temp1);
    mpz_init(temp2);
    mpz_init(temp3);

    // Handle negative indices
    If n >= 0 Then
        abs_n := QWord(n)
    Else
        abs_n := QWord(-n);

    target := abs_n;
    sign := (n < 0) And ((abs_n Mod 2) = 0);

    // Initialize base Fibonacci numbers (0-8)
    SetLength(FDict, 9);
    For i := 0 To 8 Do
    Begin
        FDict[i].key := QWord(i);
        mpz_init(FDict[i].value);
    End;

    mpz_set_ui(FDict[0].value, 0);   // F(0) = 0
    mpz_set_ui(FDict[1].value, 1);   // F(1) = 1
    mpz_set_ui(FDict[2].value, 1);   // F(2) = 1
    mpz_set_ui(FDict[3].value, 2);   // F(3) = 2
    mpz_set_ui(FDict[4].value, 3);   // F(4) = 3
    mpz_set_ui(FDict[5].value, 5);   // F(5) = 5
    mpz_set_ui(FDict[6].value, 8);   // F(6) = 8
    mpz_set_ui(FDict[7].value, 13);  // F(7) = 13
    mpz_set_ui(FDict[8].value, 21);  // F(8) = 21

    // If n is small, return directly
    If abs_n <= 8 Then
    Begin
        idx := FindF(abs_n);
        If idx >= 0 Then
            mpz_set(result, FDict[idx].value);

        If sign Then
            mpz_neg(result, result);

        // Cleanup
        For i := 0 To 8 Do
            mpz_clear(FDict[i].value);
        mpz_clear(temp1);
        mpz_clear(temp2);
        mpz_clear(temp3);

        endTime := Now;
        WriteLn('Hybrid method time: ', MilliSecondsBetween(endTime, startTime), ' ms');
        Exit;
    End;

    // Build division path
    SetLength(DivMap, 0);
    a := abs_n;

    // Python: while a > 1:
    While a > 1 Do
    Begin
        // Python: div = 3 if a % 3.0 == 0.0 else 2
        If (a Mod 3) = 0 Then
            divBy := 3
        Else
            divBy := 2;

        a := a Div divBy;

        // Python: _[a] = div
        SetLength(DivMap, Length(DivMap) + 1);
        DivMap[Length(DivMap) - 1].key := a;
        DivMap[Length(DivMap) - 1].divisor := divBy;
    End;

    // Python: _[a] = div (final assignment)
    SetLength(DivMap, Length(DivMap) + 1);
    DivMap[Length(DivMap) - 1].key := a;
    DivMap[Length(DivMap) - 1].divisor := divBy;

    // Sort keys in increasing order
    SetLength(sortedKeys, Length(DivMap));
    For i := 0 To Length(DivMap) - 1 Do
        sortedKeys[i] := DivMap[i].key;

    // Simple bubble sort
    For i := 0 To Length(sortedKeys) - 2 Do
        For j := i + 1 To Length(sortedKeys) - 1 Do
            If sortedKeys[i] > sortedKeys[j] Then
            Begin
                a := sortedKeys[i];
                sortedKeys[i] := sortedKeys[j];
                sortedKeys[j] := a;
            End;

    Write('Operations: ');

    // Process each key in sorted order
    For i := 0 To Length(sortedKeys) - 1 Do
    Begin
        a := sortedKeys[i];

        // Find the divisor for this key
        divBy := 0;
        For j := 0 To Length(DivMap) - 1 Do
            If DivMap[j].key = a Then
            Begin
                divBy := DivMap[j].divisor;
                Break;
            End;

        If divBy = 0 Then
            Continue;

        nextNum := a * divBy;  // Python: i = _[n] * n

        If divBy = 2 Then
        Begin
            Write('² ');

            // Need F(a-1) and F(a)
            j := FindF(a - 1);
            idx := FindF(a);

            If (j < 0) or (idx < 0) Then
            Begin
                WriteLn('Error: Missing base Fibonacci numbers for doubling at a=', a);
                Halt(1);
            End;

            // F(i-1) = F(a-1)² + F(a)²
            AddF(nextNum - 1);
            mpz_mul(temp1, FDict[j].value, FDict[j].value);  // F(a-1)²
            mpz_mul(temp2, FDict[idx].value, FDict[idx].value);  // F(a)²
            mpz_add(FDict[Length(FDict) - 1].value, temp1, temp2);

            // Check if we found target
            If (nextNum - 1) = target Then
                Break;

            // F(i) = (2 * F(a-1) + F(a)) * F(a)
            AddF(nextNum);
            mpz_mul_ui(temp1, FDict[j].value, 2);  // 2 * F(a-1)
            mpz_add(temp1, temp1, FDict[idx].value);  // 2*F(a-1) + F(a)
            mpz_mul(FDict[Length(FDict) - 1].value, temp1, FDict[idx].value);

            // Check if we found target
            If nextNum = target Then
                Break;

            // CRITICAL FIX: Always compute F(i+1) and F(i+2)**
            // F(i+1) = F(i-1) + F(i)
            AddF(nextNum + 1);
            j := FindF(nextNum - 1);
            idx := FindF(nextNum);
            mpz_add(FDict[Length(FDict) - 1].value, FDict[j].value, FDict[idx].value);

            // Check if we found target
            If (nextNum + 1) = target Then
                Break;

            // F(i+2) = F(i) + F(i+1)
            AddF(nextNum + 2);
            j := FindF(nextNum);
            idx := FindF(nextNum + 1);
            mpz_add(FDict[Length(FDict) - 1].value, FDict[j].value, FDict[idx].value);

            // Check if we found target
            If (nextNum + 2) = target Then
                Break;
        End
        Else If divBy = 3 Then
        Begin
            Write('³ ');

            // Need F(a) and ensure F(a+1) is available**
            idx := FindF(a);
            If idx < 0 Then
            Begin
                WriteLn('Error: Missing base Fibonacci number for tripling at a=', a);
                Halt(1);
            End;

            // Ensure F(a+1) is available**
            EnsureFPlusOne(a);
            j := FindF(a + 1);

            // F(i) = 5 * F(a)³ + 3 * (-1)^a * F(a)
            AddF(nextNum);

            // Compute F(a)² and F(a)³
            mpz_mul(temp1, FDict[idx].value, FDict[idx].value);  // F(a)²
            mpz_mul(temp2, temp1, FDict[idx].value);  // F(a)³

            // 5 * F(a)³
            mpz_mul_ui(temp3, temp2, 5);

            // 3 * (-1)^a * F(a)
            If (a Mod 2) = 0 Then
            Begin
                // (-1)^a = 1 for even a
                mpz_mul_ui(temp1, FDict[idx].value, 3);
                mpz_add(FDict[Length(FDict) - 1].value, temp3, temp1);
            End
            Else
            Begin
                // (-1)^a = -1 for odd a
                mpz_mul_ui(temp1, FDict[idx].value, 3);
                mpz_neg(temp1, temp1);
                mpz_add(FDict[Length(FDict) - 1].value, temp3, temp1);
            End;

            // Check if we found target
            If nextNum = target Then
                Break;

            // CRITICAL FIX: Always compute the window**
            // F(i+1) = F(a+1)³ + 3 * F(a+1) * F(a)² - F(a)³
            AddF(nextNum + 1);

            // F(a+1)³
            mpz_mul(temp1, FDict[j].value, FDict[j].value);
            mpz_mul(temp1, temp1, FDict[j].value);

            // 3 * F(a+1) * F(a)²
            mpz_mul(temp2, FDict[idx].value, FDict[idx].value);  // F(a)²
            mpz_mul_ui(temp3, FDict[j].value, 3);  // 3 * F(a+1)
            mpz_mul(temp3, temp3, temp2);  // 3 * F(a+1) * F(a)²

            // F(a)³
            mpz_mul(temp2, temp2, FDict[idx].value);  // F(a)³

            // F(i+1) = F(a+1)³ + 3*F(a+1)*F(a)² - F(a)³
            mpz_add(FDict[Length(FDict) - 1].value, temp1, temp3);
            mpz_sub(FDict[Length(FDict) - 1].value, FDict[Length(FDict) - 1].value, temp2);

            // Check if we found target
            If (nextNum + 1) = target Then
                Break;

            // F(i-1) = F(i+1) - F(i)
            AddF(nextNum - 1);
            j := FindF(nextNum + 1);
            idx := FindF(nextNum);
            mpz_sub(FDict[Length(FDict) - 1].value, FDict[j].value, FDict[idx].value);

            // Check if we found target
            If (nextNum - 1) = target Then
                Break;

            // F(i+2) = F(i) + F(i+1)
            AddF(nextNum + 2);
            j := FindF(nextNum);
            idx := FindF(nextNum + 1);
            mpz_add(FDict[Length(FDict) - 1].value, FDict[j].value, FDict[idx].value);

            // Check if we found target
            If (nextNum + 2) = target Then
                Break;

            // F(i+3) = F(i+1) + F(i+2)
            AddF(nextNum + 3);
            j := FindF(nextNum + 1);
            idx := FindF(nextNum + 2);
            mpz_add(FDict[Length(FDict) - 1].value, FDict[j].value, FDict[idx].value);

            // Check if we found target
            If (nextNum + 3) = target Then
                Break;
        End;
    End;

    WriteLn;

    // Get the result
    idx := FindF(target);
    If idx < 0 Then
    Begin
        WriteLn('Error: Could not compute F(', n, ')');
        Halt(1);
    End;

    mpz_set(result, FDict[idx].value);

    // Apply sign for negative indices
    If sign Then
        mpz_neg(result, result);

    // Cleanup
    For i := 0 To Length(FDict) - 1 Do
        mpz_clear(FDict[i].value);

    mpz_clear(temp1);
    mpz_clear(temp2);
    mpz_clear(temp3);

    endTime := Now;
    WriteLn('Hybrid method time: ', MilliSecondsBetween(endTime, startTime), ' ms');
End;

// ----------------------------------------------------------------------------
// Display Fibonacci number with first/last digits and total count
// ----------------------------------------------------------------------------
Procedure DisplayLargeFibonacci(n: Int64; Var fib: mpz_t);
Var
    s: AnsiString;
    len: Integer;
    first20, last20: AnsiString;
Begin
    s := mpz_get_str(Nil, 10, fib);
    len := Length(s);

    WriteLn('F(', n, ') has ', len, ' digits');

    If len <= 40 Then
        WriteLn('F(', n, ') = ', s)
    Else
    Begin
        first20 := Copy(s, 1, 20);
        last20 := Copy(s, len - 19, 20);
        WriteLn('First 20 digits: ', first20);
        WriteLn('Last 20 digits:  ', last20);
        WriteLn('Full number saved to memory');
    End;
    WriteLn;
End;

// ----------------------------------------------------------------------------
// Simple iterative Fibonacci (for comparison, limited to smaller n)
// ----------------------------------------------------------------------------
Procedure FibonacciIterative(n: Integer; Var result: mpz_t);
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
    Begin
        mpz_set_si(result, 0);
    End
    Else
    Begin
        mpz_set_si(a, 0);
        mpz_set_si(b, 1);

        For i := 2 To abs_n Do
        Begin
            mpz_add(temp, a, b);
            mpz_set(a, b);
            mpz_set(b, temp);
        End;

        mpz_set(result, b);
    End;

    // Handle negative indices using: F(-n) = (-1)^(n+1) * F(n)
    If n < 0 Then
    Begin
        If (abs_n Mod 2) = 0 Then
            mpz_neg(result, result);
    End;

    mpz_clear(a);
    mpz_clear(b);
    mpz_clear(temp);

    endTime := Now;
    WriteLn('Iterative method time: ', MilliSecondsBetween(endTime, startTime), ' ms');
End;

// ----------------------------------------------------------------------------
// Parse a string to Int64, handling large numbers
// ----------------------------------------------------------------------------
Function ParseLargeInt(Str: String): Int64;
Var
    ErrorCode: Integer;
Begin
    Val(Str, Result, ErrorCode);
    If ErrorCode <> 0 Then
        Raise EConvertError.Create('Invalid integer: ' + Str);
End;

// ----------------------------------------------------------------------------
// Parse algorithm selection from string
// ----------------------------------------------------------------------------
Function ParseAlgorithm(Str: String): TAlgorithm;
Var
    lowerStr: String;
Begin
    lowerStr := LowerCase(Str);
    If lowerStr = 'matrix' Then
        Result := algMatrix
    Else If lowerStr = 'fastdoubling' Then
        Result := algFastDoubling
    Else If lowerStr = 'iterative' Then
        Result := algIterative
    Else If lowerStr = 'hybrid' Then
        Result := algHybrid
    Else
        Raise EConvertError.Create('Invalid algorithm: ' + Str + '. Use: matrix, fastdoubling, iterative, or hybrid');
End;

// ----------------------------------------------------------------------------
// Benchmark all methods for a given n
// ----------------------------------------------------------------------------
Procedure BenchmarkMethods(n: Int64);
Var
    result1, result2, result3, result4: mpz_t;
    s1, s2, s3, s4: AnsiString;
    startTime, endTime: TDateTime;
Begin
    WriteLn('========================================');
    WriteLn('Benchmarking F(', n, ')');
    WriteLn('========================================');

    mpz_init(result1);
    mpz_init(result2);
    mpz_init(result3);
    mpz_init(result4);

    // Benchmark Matrix method
    WriteLn;
    WriteLn('1. Matrix Exponentiation Method:');
    startTime := Now;
    FibonacciMatrix(n, result1);
    endTime := Now;
    s1 := mpz_get_str(Nil, 10, result1);
    WriteLn('Result length: ', Length(s1), ' digits');
    WriteLn('Total time: ', MilliSecondsBetween(endTime, startTime), ' ms');

    // Benchmark Fast Doubling method
    WriteLn;
    WriteLn('2. Fast Doubling Method:');
    startTime := Now;
    FibonacciFastDoubling(n, result2);
    endTime := Now;
    s2 := mpz_get_str(Nil, 10, result2);
    WriteLn('Result length: ', Length(s2), ' digits');
    WriteLn('Total time: ', MilliSecondsBetween(endTime, startTime), ' ms');

    // Benchmark Hybrid method
    WriteLn;
    WriteLn('3. Hybrid Doubling/Tripling Method:');
    startTime := Now;
    FibonacciHybrid(n, result3);
    endTime := Now;
    s3 := mpz_get_str(Nil, 10, result3);
    WriteLn('Result length: ', Length(s3), ' digits');
    WriteLn('Total time: ', MilliSecondsBetween(endTime, startTime), ' ms');

    // Verify results match
    If (mpz_cmp(result1, result2) = 0) and (mpz_cmp(result2, result3) = 0) Then
        WriteLn('✓ All results match!')
    Else
        WriteLn('✗ ERROR: Results do not match!');

    // Benchmark Iterative method if n is small enough
    If (n >= Low(Integer)) And (n <= High(Integer)) And (Abs(n) <= 100000) Then
    Begin
        WriteLn;
        WriteLn('4. Iterative Method (for comparison):');
        startTime := Now;
        FibonacciIterative(Integer(n), result4);
        endTime := Now;
        s4 := mpz_get_str(Nil, 10, result4);
        WriteLn('Result length: ', Length(s4), ' digits');
        WriteLn('Total time: ', MilliSecondsBetween(endTime, startTime), ' ms');

        If mpz_cmp(result1, result4) = 0 Then
            WriteLn('✓ Iterative result matches!')
        Else
            WriteLn('✗ ERROR: Iterative result does not match!');
    End
    Else
    Begin
        WriteLn;
        WriteLn('4. Iterative Method: Skipped (n too large)');
    End;

    WriteLn;

    mpz_clear(result1);
    mpz_clear(result2);
    mpz_clear(result3);
    mpz_clear(result4);
End;

// ----------------------------------------------------------------------------
// Main program with CLI argument handling
// ----------------------------------------------------------------------------
Var
    fib_gmp: mpz_t;
    n: Int64;
    i: Integer;
    algorithm: TAlgorithm;
    benchmarkMode: Boolean;

Begin
    // Initialize GMP result
    mpz_init(fib_gmp);

    // Check command line arguments
    If ParamCount >= 1 Then
    Begin
        // Parse first argument as 64-bit integer
        Try
            n := ParseLargeInt(ParamStr(1));

            // Check for algorithm selection (second argument)
            algorithm := algMatrix;  // Default
            benchmarkMode := False;

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
                        Begin
                            WriteLn('Warning: ', E.Message);
                            WriteLn('Using default algorithm: matrix');
                        End;
                    End;
                End;
            End;

            If benchmarkMode Then
            Begin
                BenchmarkMethods(n);
            End
            Else
            Begin
                // Compute Fibonacci number with selected algorithm
                Case algorithm Of
                    algMatrix:
                    Begin
                        WriteLn('Computing F(', n, ') using matrix exponentiation...');
                        FibonacciMatrix(n, fib_gmp);
                    End;

                    algFastDoubling:
                    Begin
                        WriteLn('Computing F(', n, ') using fast doubling...');
                        FibonacciFastDoubling(n, fib_gmp);
                    End;

                    algIterative:
                    Begin
                        // For iterative method, we need to check if n fits in 32-bit
                        If (n < Low(Integer)) Or (n > High(Integer)) Then
                        Begin
                            WriteLn('Error: Iterative method only supports n between ',
                                    Low(Integer), ' and ', High(Integer));
                            WriteLn('Use matrix, fastdoubling, or hybrid method for larger values.');
                            Halt(1);
                        End;

                        WriteLn('Computing F(', n, ') using iterative method...');
                        FibonacciIterative(Integer(n), fib_gmp);
                    End;

                    algHybrid:
                    Begin
                        WriteLn('Computing F(', n, ') using hybrid (doubling/tripling) method...');
                        FibonacciHybrid(n, fib_gmp);
                    End;
                End;

                // Display result
                DisplayLargeFibonacci(n, fib_gmp);
            End;

        Except
            On E: EConvertError Do
                WriteLn('Error: ', E.Message);
        End;
    End
    Else
    Begin
        // No arguments: run demonstration
        WriteLn('No command line argument provided. Running demonstration...');
        WriteLn;
        WriteLn('========================================');
        WriteLn('Fibonacci Sequence Demonstration');
        WriteLn('========================================');
        WriteLn;

        // Test from -10 to 10
        WriteLn('Fibonacci numbers from -10 to 10 (using fast doubling):');
        For i := -10 To 10 Do
        Begin
            FibonacciFastDoubling(i, fib_gmp);
            WriteLn('F(', i:3, ') = ', mpz_get_str(Nil, 10, fib_gmp));
        End;
        WriteLn;

        // Benchmark different methods for moderate n
        WriteLn('Benchmark for n = 1,000,000:');
        BenchmarkMethods(1000000);

        // Benchmark for larger n
        WriteLn('Benchmark for n = 10,000,000:');
        BenchmarkMethods(10000000);

        // Comparison with iterative method for small n
        WriteLn('Comparison for small n (30):');
        Write('Matrix method: ');
        FibonacciMatrix(30, fib_gmp);
        WriteLn(mpz_get_str(Nil, 10, fib_gmp));

        Write('Hybrid method: ');
        FibonacciHybrid(30, fib_gmp);
        WriteLn(mpz_get_str(Nil, 10, fib_gmp));

        Write('Iterative method: ');
        FibonacciIterative(30, fib_gmp);
        WriteLn(mpz_get_str(Nil, 10, fib_gmp));
        WriteLn;

        WriteLn('Usage examples:');
        WriteLn('  ./FastFibonacciGMP 100                             # Compute F(100) with matrix (default)');
        WriteLn('  ./FastFibonacciGMP 100 -a=fastdoubling             # Compute with fast doubling');
        WriteLn('  ./FastFibonacciGMP 100 -a=hybrid                   # Compute with hybrid method (recommended)');
        WriteLn('  ./FastFibonacciGMP 100 -a=iterative                # Compute with iterative (small n only)');
        WriteLn('  ./FastFibonacciGMP 1000000 -benchmark              # Benchmark all methods');
        WriteLn('  ./FastFibonacciGMP -50 -a=fastdoubling             # Compute negative Fibonacci');
        WriteLn('  ./FastFibonacciGMP 18000000000 -a=hybrid # Compute large F(18^9) takes 11GB, 154701 ms to calculate/20 mins to write out');
        WriteLn;
        WriteLn('Available algorithms:');
        WriteLn('  matrix         : Matrix exponentiation (O(log n))');
        WriteLn('  fastdoubling   : Fast doubling iterative (O(log n), very fast)');
        WriteLn('  hybrid         : Hybrid doubling/tripling (O(log n), fastest for large n) ★ RECOMMENDED');
        WriteLn('  iterative      : Iterative method (O(n), for small n ≤ 100000 only)');
    End;

    // Cleanup
    mpz_clear(fib_gmp);

    WriteLn('Program completed.');
End.
(*)
*)  AI means corrected logic for AI itself: the first attempts were mistranslations
**) AI Finally understood what the algorithm is doing (after 12 sessions)
(*)
<PRE>
