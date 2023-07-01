: (orderDisjoint '(the cat sat on the mat) '(mat cat))
-> (the mat sat on the cat)

: (orderDisjoint '(the cat sat on the mat) '(cat mat))
-> (the cat sat on the mat)

: (orderDisjoint '(A B C A B C A B C) '(C A C A))
-> (C B A C B A A B C)

: (orderDisjoint '(A B C A B D A B E) '(E A D A))
-> (E B C A B D A B A)

: (orderDisjoint '(A B) '(B))
-> (A B)

: (orderDisjoint '(A B) '(B A))
-> (B A)

: (orderDisjoint '(A B B A) '(B A))
-> (B A B A)
