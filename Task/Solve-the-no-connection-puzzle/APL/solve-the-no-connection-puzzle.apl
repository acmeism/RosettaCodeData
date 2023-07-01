     perms←{
     ⍝∇ 20100513/20140818 ra⌈ --()--
        1=⍴⍴⍵:⍵[∇ ''⍴⍴⍵]
       ↑{0∊⍴⍵:⍵ ⋄ (⍺[1]⌷⍵),(1↓⍺)∇ ⍵~⍺[1]⌷⍵}∘(⍳⍵)¨↓⍉1+(⌽⍳⍵)⊤¯1+⍳!⍵
   }

solution←{
    links←  (3 4 5) (4 5 6) (1 4 7) (1 2 3 5 7 8) (1 2 4 6 7 8) (2 5 8) (3 4 5) (4 5 6) ⍝ node i connects with nodes i⊃links
    tries←8 perms 8
    fails←{1∊{1∊⍵∊¯1 0 1}¨|⍺-¨⍺∘{⍺[⍵]}¨⍵}
  ⍝    ⍴⍸~tries fails ⍤1⊢links
  ⍝ 16
   solns←⍸~tries fails ⍤1⊢links
   tries[''⍴solns;]
   }
