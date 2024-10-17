isPalin1=: 0:`($:@}.@}:)@.({.={:)`1:@.(1>:#)

isPalin2=: monad define
 if. 1>:#y do. 1 return. end.
 if. ({.={:)y do. isPalin2 }.}:y else. 0 end.
)
