; The computer will evaluate expressions written in -- possibly nested -- parentheses, where the first symbol gives the operation and any subsequent symbols or numbers give the operands.

; For instance, (+ (+ 2 2) (- 7 5)) evaluates to 6.

; We define our problem as a function:

(define (try n)

; We are looking for a value of n that leaves 269,696 as the remainder when its square is divided by a million.

; The symbol * stands for multiplication.

    (if (= (remainder (* n n) 1000000) 269696)

; If this condition is met, the function should give us the value of n:

        n

; If not, it should try n+1:

        (try (+ n 1))))

; We supply our function with 1 as an initial value to test, and ask the computer to print the final result.

(print (try 1))
