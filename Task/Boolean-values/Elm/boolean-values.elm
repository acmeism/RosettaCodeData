--True and False directly represent Boolean values in Elm
--For eg to show yes for true and no for false
if True then "yes" else "no"

--Same expression differently
if False then "no" else "yes"

--This you can run as a program
--Elm allows you to take anything you want for representation
--In the program we take T for true F for false
import Html exposing(text,div,Html)
import Html.Attributes exposing(style)

type Expr = T | F | And Expr Expr | Or Expr Expr | Not Expr

evaluate : Expr->Bool
evaluate expression =
 case expression of
 T ->
  True

 F ->
  False

 And expr1 expr2 ->
  evaluate expr1 && evaluate expr2

 Or expr1 expr2 ->
  evaluate expr1 || evaluate expr2

 Not expr ->
  not (evaluate expr)

--CHECKING RANDOM LOGICAL EXPRESSIONS
ex1= Not F
ex2= And T F
ex3= And (Not(Or T F)) T

main =
    div [] (List.map display  [ex1, ex2, ex3])

display expr=
   div [] [ text ( toString expr ++ "-->" ++ toString(evaluate expr) ) ]
--END
