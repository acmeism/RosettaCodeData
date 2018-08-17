: (->) ( n <text> -- )
           OVER 1 10 BETWEEN 0= ABORT" out of range!"
           >BODY ! ;

: ->      ( n -- )
           STATE @
           IF   POSTPONE [']  POSTPONE (->) \ compiling action
           ELSE '  (->)                     \ interpret action
           THEN ; IMMEDIATE
