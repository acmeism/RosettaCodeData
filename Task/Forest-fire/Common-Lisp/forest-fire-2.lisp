CL-USER>(defparameter *forest* (make-new-forest))
CL-USER>(simulate *forest* 5)
------ Initial forest ------
TTTTT   TT
   TTT  TT
 TT T  T
 TTTT T TT
T TT  T  T
    T  TTT
  TTTT TTT
 T
 T T T T
TTT TTT  T

------ Generation 1 ------
TTTTT   TT
   TTT  TT
 TT T  T
 TTTT T TT
T TT  T  T
    T  TTT
  TTTT TTT
 T
 T T T T
TTT TTT  T

------ Generation 2 ------
TTTTT   TT
   TTT  TT
 TT T  T
 TTTT T TT
TTTT  T  T
    T  TTT
  TTT# TTT
 T
 T T T T
TTT TTT  T

------ Generation 3 ------
TTTTT   TT
   TTT  TT
 TT T  T
 TTTT T TT
TTTT  T  T
    #  TTT
  TT#  TTT
 T
 T T T T
TTT TTT  T

------ Generation 4 ------
TTTTT   TT
   TTT  TT
 TT T  TT
 TTTT T TT
TTT#  T  T
       TTT
  T#   TTT
 T
 T T T T
TTT TTT  T

------ Generation 5 ------
TTTTT   TT
   TTT  TT
 TT T  TT
 T### T TT
TT#   T  T
       TTT
  #    TTT
 T
 T T T T
TTT TTT  T
NIL
