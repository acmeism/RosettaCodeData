   sr=. [ apply f. ,&<             NB. Self referring
   lv=. ]:^:_1 b.]:`(<'0';_1)`:6   NB. Linear representation of a verb operand
   Y=. ]:&>/lv&sr                  NB. Y with embedded states
   Y=. 'Y' f.                      NB. Fixing it...
   Y                               NB. ... To make it stateless (i.e., a combinator)
((]: & >) / ((((]: ^: (_1)) b. ]:) ` (<'0';_1)) `: 6)) & ([ 128!:2 ,&<)
