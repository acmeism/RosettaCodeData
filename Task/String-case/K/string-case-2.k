s:"alphaBETA"
upper: {`c$x+-32*(x>"`")*x<"{"}
lower: {`c$x+32*(x>"@")*x<"["}
lower:_: / built in

upper "This is a test."
"THIS IS A TEST."
lower "This is a test."
"this is a test."
lower s
"alphabeta"
upper s
"ALPHABETA"
