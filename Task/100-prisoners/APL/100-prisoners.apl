∇ R ← random Nnc; N; n; c
  (N n c) ← Nnc
  R ← ∧/{∨/⍵=c[n?N]}¨⍳N
∇

∇ R ← follow Nnc; N; n; c; b
  (N n c) ← Nnc
  b ← n N⍴⍳N
  R ← ∧/∨⌿b={⍺⊢c[⍵]}⍀n N⍴c
∇

∇ R ← M timesSimPrisoners Nn; N; n; m; c; r; s
  (N n) ← Nn
  R ← 0 0
  m ← M
  LOOP: c←N?N
  r ← random N n c
  s ← follow N n c
  R ← R + r,s
  →((m←m-1)>0)/LOOP
  R ← R ÷ M
∇

⎕TS
'>>>>>'
1000 timesSimPrisoners 100 50
'>>>>>'
⎕TS

