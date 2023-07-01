: (truthTable (str "A and (B or C)"))
A      B      C
NIL    NIL    NIL    NIL
T      NIL    NIL    NIL
NIL    T      NIL    NIL
T      T      NIL    T
NIL    NIL    T      NIL
T      NIL    T      T
NIL    T      T      NIL
T      T      T      T

: (truthTable (str "not (Foo and (Bar or Mumble))"))
Foo    Bar    Mumble
NIL    NIL    NIL    T
T      NIL    NIL    T
NIL    T      NIL    T
T      T      NIL    NIL
NIL    NIL    T      T
T      NIL    T      NIL
NIL    T      T      T
T      T      T      NIL

: (truthTable (str "(A xor B) and (B or C)"))
A      B      C
NIL    NIL    NIL    NIL
T      NIL    NIL    NIL
NIL    T      NIL    T
T      T      NIL    NIL
NIL    NIL    T      NIL
T      NIL    T      T
NIL    T      T      T
T      T      T      NIL

: (truthTable (str "(A xor B) and ((not B) or C)"))
A      B      C
NIL    NIL    NIL    NIL
T      NIL    NIL    T
NIL    T      NIL    NIL
T      T      NIL    NIL
NIL    NIL    T      NIL
T      NIL    T      T
NIL    T      T      T
T      T      T      NIL
