⍝ Find the intersection of a line with a plane
⍝ The intersection I belongs to a line defined by point L and vector V, translates to:
⍝ A real parameter t exists, that satisfies I = L + tV
⍝ I belongs to the plan defined by point P and normal vector N. This means that any two points of the plane make a vector
⍝ normal to vector N. As I and P belong to the plane, the vector IP is normal to N.
⍝ This translates to: The scalar product IP.N = 0.
⍝ (P - I).N = 0 <=> (P - L - tV).N = 0
⍝ Using distributivity, then associativity, the following equations are established:
⍝ (P - L - tV).N = (P - L).N - (tV).N = (P - L).N - t(V.N) = 0
⍝ Which allows to resolve t: t = ((P - L).N) ÷ (V.N)
⍝ In APL, A.B is coded +/A x B
  V ← 0 ¯1 ¯1
  L ← 0 0 10
  N ← 0 0 1
  P ← 0 0 5
  dot ← { +/ ⍺ × ⍵ }
  t ← ((P - L) dot N) ÷ V dot N
  I ← L + t × V
