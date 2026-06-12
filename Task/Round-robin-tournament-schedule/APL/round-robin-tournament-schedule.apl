∇ SCHEDULER N;R;I
  R←(⍳N),(2|N)⍴'-'
  I←0 ⋄ N←⍴(R)
 L:⎕←'ROUND',I←I+1
  ⎕←((N÷2)↑R),[0.5]⌽(N÷2)↓R
  R←(1↑R),1⌽1↓R
  →(I<N-1)/L
∇
