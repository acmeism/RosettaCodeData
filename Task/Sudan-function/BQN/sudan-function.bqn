_sudan←{
   x 0 _𝕣 y: x + y;
   x n _𝕣 0: x;
   x n _𝕣 y: k (n-1)_𝕣 y+k←x𝕊y-1
}

•Show "⍉(↕7) 0 _sudan⌜ ↕6:"
•Show ⍉(↕7) 0 _sudan⌜ ↕6

•Show "⍉(↕7) 1 _sudan⌜ ↕6:"
•Show ⍉(↕7) 1 _sudan⌜ ↕6

•Show "1 2 _sudan 1: "∾•Fmt 1 2 _sudan 1
•Show "2 2 _sudan 1: "∾•Fmt 2 2 _sudan 1
•Show "1 3 _sudan 1: "∾•Fmt 1 3 _sudan 1
