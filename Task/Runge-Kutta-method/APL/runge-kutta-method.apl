      ∇RK4[⎕]∇
    ∇
[0]   Z←R(Y¯ RK4)Y;T;YN;TN;∆T;∆Y1;∆Y2;∆Y3;∆Y4
[1]   (T R ∆T)←R
[2]  LOOP:→(R≤TN←¯1↑T)/EXIT
[3]   ∆Y1←∆T×TN Y¯ YN←¯1↑Y
[4]   ∆Y2←∆T×(TN+∆T÷2)Y¯ YN+∆Y1÷2
[5]   ∆Y3←∆T×(TN+∆T÷2)Y¯ YN+∆Y2÷2
[6]   ∆Y4←∆T×(TN+∆T)Y¯ YN+∆Y3
[7]   Y←Y,YN+(∆Y1+(2×∆Y2)+(2×∆Y3)+∆Y4)÷6
[8]   T←T,TN+∆T
[9]   →LOOP
[10] EXIT:Z←T,[⎕IO+.5]Y
    ∇

      ∇PRINT[⎕]∇
    ∇
[0]   PRINT;TABLE
[1]   TABLE←0 10 .1({⍺×⍵*.5}RK4)1
[2]   ⎕←'T' 'RK4 Y' 'ERROR'⍪TABLE,TABLE[;2]-{((4+⍵*2)*2)÷16}TABLE[;1]
    ∇
