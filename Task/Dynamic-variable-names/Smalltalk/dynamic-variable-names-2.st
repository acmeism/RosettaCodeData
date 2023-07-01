| varName |
varName := Stdin request: 'Enter a global variable name:'.
Smalltalk at:varName asSymbol put:42.
expr := Stdin request:'Enter an expression:'.
(Compiler evaluate:expr) printCR
