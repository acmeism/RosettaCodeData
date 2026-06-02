' ============================================
' https://rosettacode.org/wiki/Variables
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================

' user-defined function
DEF FN MyFunc$(param$)
    PRINT param$  			' Output: text
    PRINT FOO#  			' Output: 123 since constant are visible everywhere
    LET myLocal$ = "Hello" 	' Not visible outside funtion MyFunc$
    RETURN myLocal$
END DEF

[inits] ' label not mandatory, just something I personally prefer
	' In BazzBasic, variables are not typed
	LET a$  				' a$ declared, but no value
	LET b$, c$, d$ = 10 	' all declared, but only d$ has value (10)
	LET name$ = "Foo", age$ ' name$ gets value, age$ not
	LET foo$ = "text"
	' Constants
	LET FOO# = 123
	LET STUFF# = "text"

' Type conversion
foo$ = 123

' constant to variable
foo$ = STUFF#

' variable to constant
LET CONST2# = foo$
PRINT FN MyFunc$(foo$)
END

' Output:
' text
' 123
' Hello
