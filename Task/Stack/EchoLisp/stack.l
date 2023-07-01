; build stack [0 1 ... 9 (top)] from a list
(list->stack (iota 10) 'my-stack)
(stack-top 'my-stack) → 9
(pop 'my-stack)  → 9
(stack-top 'my-stack) → 8
(push 'my-stack '🐸) ; any kind of lisp object in the stack
(stack-empty? 'my-stack) → #f
(stack->list 'my-stack) ; convert stack to list
    → (0 1 2 3 4 5 6 7 8 🐸)
(stack-swap 'my-stack) ; swaps two last items
    → 8 ; new top
(stack->list 'my-stack)
     → (0 1 2 3 4 5 6 7 🐸 8) ; swapped
(while (not (stack-empty? 'my-stack)) (pop 'my-stack)) ; pop until empty
(stack-empty? 'my-stack)  → #t ; true

(push 'my-stack 7)
my-stack ; a stack is not a variable, nor a symbol - cannot be evaluated
   ⛔ error: #|user| : unbound variable : my-stack
(stack-top 'my-stack)  → 7
