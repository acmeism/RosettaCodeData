/+  *roman
:-  %say
|=  [* [x=$%([%from-roman tape] [%to-roman @ud]) ~] ~]
:-  %noun
^-  tape
?-  -.x
  %from-roman  "{<(parse +.x)>}"
  %to-roman  (yield +.x)
==
