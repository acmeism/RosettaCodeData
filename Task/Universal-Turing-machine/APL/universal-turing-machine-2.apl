∆I ←'QA.1' '1' 'R' 'QA'
∆I,←'QA.B' '1' 'N' 'QB'
∆INCREMENTER←∆I

∆B ←'QA.0' '1' 'R' 'QB'
∆B,←'QA.1' '1' 'L' 'QC'
∆B,←'QB.0' '1' 'L' 'QA'
∆B,←'QB.1' '1' 'R' 'QB'
∆B,←'QC.0' '1' 'L' 'QB'
∆B,←'QC.1' '1' 'N' 'QD'
∆BEAVER←∆B

∇ R←RUN(F Q H T B);I;J
  I←1 ⋄ T←,T
 L:→(Q≡H)/E
  J←⍸(Q,'.',T[I])∘≡¨F
  T[I]←F[J+1]
  I←I+2-'RNL'⍳F[J+2]
  Q←⊃F[J+3]
  T←((I<1)⍴B),T,(I>⍴T)⍴B
  I←I+I=0
  →L
 E:R←T I
∇
