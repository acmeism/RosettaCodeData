Red []
orig: [] repeat i 10 [append orig i]
?? orig
cpy: [] forall orig [if even? orig/1 [append cpy orig/1]]
;; or - because we know each second element is even :- )
;; cpy: extract next orig 2
?? cpy
remove-each ele orig [odd? ele]    ;; destructive
?? orig
