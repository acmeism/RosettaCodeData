Caution! The apparent gaps in the sequence of precedence values in this table are *not* unused!
Cunning ploys with precedence allow parameter evaluation, and right-to-left order as in x**y**z.
       INTEGER		OPSYMBOLS		!Recognised operator symbols.
       PARAMETER	(OPSYMBOLS = 25)	!There are also some associates.
       TYPE SYMB		!To recognise symbols and carry associated information.
        CHARACTER*2	IS		!Its text. Careful with the trailing space and comparisons.
        INTEGER*1	PRECEDENCE	!Controls the order of evaluation.
        INTEGER*1	POPCOUNT	!Stack activity: a+b means + requires two in.
        CHARACTER*48	USAGE		!Description.
       END TYPE SYMB		!The cross-linkage of precedences is tricky.
       CHARACTER*5	IFPARTS(0:4)	!These appear when an operator would otherwise be expected.
       PARAMETER       (IFPARTS = (/"IF","THEN","ELSE","OWISE","FI"/))	!So, bend the usage of "operator".
       TYPE(SYMB) SYMBOL(-4:OPSYMBOLS)	!Righto, I'll have some.
       PARAMETER (SYMBOL =(/	!Note that "*" is not to be seen as a match to "**".
     4  SYMB("FI", 2,0,"the FI that ends an IF-statement."),	!These negative entries are not for name matching
     3  SYMB("Ow", 3,0,"the OWISE part of an IF-statement."),	!Which is instead done via IFPARTS
     2  SYMB("El", 3,0,"the ELSE part of an IF-statement."),	!But are here to take advantage of the structure in place.
     1  SYMB("Th", 3,0,"the THEN part of an IF-statement."),	!The IF is recognised separately, when expecting an operand.
     o  SYMB("  ", 0,0,"Not recognised as an operator's symbol."),
     1  SYMB("  ", 1,0,"separates symbols and aids legibility."),
C                  2 and 3 are used for the parts of an IF-statement. See PRIF.
C                  3 These precedences ensure the desired order of evaluation.
     2  SYMB(") ", 4,0,"opened with ( to bracket a sub-expression."),
     3  SYMB("] ", 4,0,"opened with [ to bracket a sub-expression."),
     4  SYMB("} ", 4,0,"opened with { to bracket a sub-expression."),
     5  SYMB(", ", 5,0,"continues a list of parameters to a function."),
C       SYMB(":=", 6,0,"marks an on-the-fly assignment of a result"), Identified differently... see PRREF.
     6  SYMB("| ", 7,2,"logical OR,  similar to addition."),
     7  SYMB("& ", 8,2,"logical AND, similar to multiplication."),
     8  SYMB("¬ ", 9,0,"logical NOT, similar to negation."),
     9  SYMB("= ",10,2,"tests for equality (beware decimal fractions)"),
     o  SYMB("< ",10,2,"tests strictly less than."),
     1  SYMB("> ",10,2,"tests strictly greater than."),
     2  SYMB("<>",10,2,"tests not equal (there is no 'not' key!)"),
     3  SYMB("¬=",10,2,"tests not equal if you can find a ¬ !"),
     4  SYMB("<=",10,2,"tests less than or equal."),
     5  SYMB(">=",10,2,"tests greater than or equal."),
     6  SYMB("+ ",11,2,"addition, and unary + to no effect."),
     7  SYMB("- ",11,2,"subtraction, and unary - for neg. numbers."),
     8  SYMB("* ",12,2,"multiplication."),
     9  SYMB("× ",12,2,"multiplication, if you can find this."),
     o  SYMB("/ ",12,2,"division."),
     1  SYMB("÷ ",12,2,"division for those with a fancy keyboard."),
     2  SYMB("\ ",12,2,"remainder a\b = a - truncate(a/b)*b; 11\3 = 2"),
C                 13 is used so that stacked ** will have lower priority than incoming **, thus delivering right-to-left evaluation.
     3  SYMB("^ ",14,2,"raise to power: also recognised is **."),	!Uses the previous precedence level also!
     4  SYMB("**",14,2,"raise to power: also recognised is ^."),
     5  SYMB("! ",15,1,"factorial, sortof, just for fun.")/))
