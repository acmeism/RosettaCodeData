|a b result|
a := 10. b := 0.
result := [a / b] on:ZeroDivide do:[:ex | ex proceedWith:Float infinity].
Transcript showCR:result.
