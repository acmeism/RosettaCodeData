N←5
grayEncode←{a≠N↑(0,a←(N⍴2)⊤⍵)}
grayDecode←{2⊥≠⌿N N↑N(2×N)⍴⍵,0,N⍴0}

grayEncode 19
