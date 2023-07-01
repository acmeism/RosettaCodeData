   A=: ~.;:'John Serena Bob Mary Serena'
   B=: ~. ;:'Jim Mary John Jim Bob'

   (A-.B) , (B-.A)   NB. Symmetric Difference
┌──────┬───┐
│Serena│Jim│
└──────┴───┘
   A (-. , -.~) B    NB. Tacit equivalent
┌──────┬───┐
│Serena│Jim│
└──────┴───┘
