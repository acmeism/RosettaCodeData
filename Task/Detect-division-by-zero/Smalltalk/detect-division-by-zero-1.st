|didDivideByZero a b|

didDivideByZero := false.
a := 10.
b := 0.
[
    a/b
] on: ZeroDivide do:[:ex |
   'you tried to divide %P by zero\n' printf:{ex suspendedContext receiver} on:Transcript.
   didDivideByZero := true.
].
didDivideByZero ifTrue:[
    Transcript show:'bad bad bad, but I already told you in the handler'.
].
