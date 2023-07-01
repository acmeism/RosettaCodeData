(context 'if2)

(define-macro (if2:if2 cond1 cond2 both-true first-true second-true neither)
  (cond
    ((eval cond1)
      (if (eval cond2)
            (eval both-true)
            (eval first-true)))
    ((eval cond2)
      (eval second-true))
    (true
      (eval neither))))

(context MAIN)

> (if2 true true 'bothTrue 'firstTrue 'secondTrue 'else)
bothTrue
> (if2 true false 'bothTrue 'firstTrue 'secondTrue 'else)
firstTrue
> (if2 false true 'bothTrue 'firstTrue 'secondTrue 'else)
secondTrue
> (if2 false false 'bothTrue 'firstTrue 'secondTrue 'else)
else
