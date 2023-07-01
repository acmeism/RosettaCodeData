import math, strformat

for x in [-5, 5]:
  for p in [2, 3]:
    echo &"x is {x:2}, ", &"p is {p:1}, ",
         &"-x^p is {-x^p:4}, ", &"-(x)^p is {-(x)^p:4}, ",
         &"(-x)^p is {(-x)^p:4}, ", &"-(x^p) is {-(x^p):4}"
