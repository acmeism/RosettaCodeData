REM Integer vs floating-Point division
Print "1. Integer division (watch out!):"
Dim As Integer a = 5, b = 2
Print "5 / 2 = "; a / b    ' Result: 2 (truncated)
Print "5 \ 2 = "; a \ b    ' Result: 2 (explicit integer division)
Print "5.0 / 2 = "; 5.0 / 2  ' Result: 2.5 (floating-point)
Print

REM Arrays start at 0 by default
Print "2. Arrays (indices from 0):"
Dim As Integer arr(1 To 3)  ' Size 3: 1,2,3
arr(1) = 10: arr(2) = 20: arr(3) = 30
Print "arr(1) = "; arr(1)
Print "arr(UBound(arr)) = "; arr(Ubound(arr))  ' Last element
Print

REM Common Shared without initialization
Print "3. COMMON Shared (not initializable):"
Common Shared globVar As Integer  ' Cannot initialize here
globVar = 999
Print "globVar = "; globVar
Print

REM Booleans are integers (0=False, non-zero=True)
Print "4. Booleans as integers:"
Dim As Boolean bool1 = True, bool2 = Not False
Print "True as integer: "; bool1     ' -1
Print "Not False: "; bool2           ' -1
Print "bool1 And bool2: "; (bool1 And bool2)  ' -1 (True)
Print

REM Empty String vs NULL Pointer
#Include Once "crt.bi"

Print "5. Empty string vs NULL pointer:"
Dim As String s1 = ""           ' Empty string
Dim As String s2                ' Uninitialized string (NULL string)
Dim As Any Ptr p1 = NULL        ' NULL pointer (crt.bi)

Print "Len("""") = "; Len(s1)
Print "Len(NULL str) = "; Len(s2)
Print "String NULL <> """": "; (s2 <> "")
Print "Pointer NULL = "; p1
Print

REM Operator precedence
Print "6. Precedence (Not vs =):"
Dim As Integer x = 5
Print "Not x = 0 ? "; (Not x = 0)     ' False (-1 = 0? No)
Print "Not (x = 0) ? "; (Not (x = 0)) ' True (correct)
Print

REM Signed vs Unsigned integers
Print "7. Signed/unsigned integers:"
Dim As Integer i = -1
Dim As Uinteger ui = 4294967295u  ' 2^32 - 1
Print "Integer(-1) = UInteger: "; Cuint(i)  ' 4294967295
Print "Comparison: "; (i = -1 Andalso ui = -1)  ' False!
Print

REM For Loop variable Scope
Print "8. FOR variable reusable:"
For i As Integer = 1 To 2
    Print "Loop 1, i = "; i
Next
For i As Integer = 10 To 11  ' New i variable!
    Print "Loop 2, i = "; i
Next
Print

REM Mid() modifies original
Print "9. Mid() modifies original string:"
Dim As String texto = "Hello World"
Dim As String parte = Mid(texto, 6, 5)
Print "Original: "; texto
Print "Part: "; parte
Print

REM Rnd() needs Randomize
Print "10. Rnd() without Randomize:"
Print "Without Randomize: "; Rnd
Randomize Timer
Print "With Randomize: "; Rnd; " "; Rnd
Print

Sleep
