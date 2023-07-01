midpts=: (1 + #) <:@(] , -:@[ , -) -:@<.@-:@(3 + #) NB. mid points of y
quartiles=: -:@(+/)@((<. ,: >.)@midpts { /:~@])  NB. quartiles of y
fivenum=: <./ , quartiles , >./                  NB. fivenum summary of y
