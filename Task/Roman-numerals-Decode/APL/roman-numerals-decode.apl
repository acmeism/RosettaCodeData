fromRoman←{
    rmn←(⎕A,⎕A,'*')[(⎕A,⎕UCS 96+⍳26)⍳⍵]     ⍝ make input uppercase
    dgt←↑'IVXLCDM' (1 5 10 50 100 500 1000) ⍝ values of roman digits
    ~rmn∧.∊⊂dgt[1;]:⎕SIGNAL 11              ⍝ domain error if non-roman input
    map←dgt[2;dgt[1;]⍳rmn]                  ⍝ map digits to values
    +/map×1-2×(2</map),0                    ⍝ subtractive principle
}
