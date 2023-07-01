∇result ← stars count; i; j; vec
 vec ← ⍬
 :for i :in ⍳ count
   vec ,← ⊂''
   :for j :in ⍳ i
     vec[i],←'*'
   :endfor
:endfor
result ← count 1 ⍴ vec
∇
