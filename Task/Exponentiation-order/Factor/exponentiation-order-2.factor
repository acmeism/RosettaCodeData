USING: formatting infix ;

[infix  5**3**2    infix]
"5**3**2   = %d\n" printf

[infix  (5**3)**2  infix]
"(5**3)**2 = %d\n" printf

[infix  5**(3**2)  infix]
"5**(3**2) = %d\n" printf
