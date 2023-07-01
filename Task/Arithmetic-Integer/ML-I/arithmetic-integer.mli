MCSKIP "WITH" NL
"" Arithmetic/Integer
"" assumes macros on input stream 1, terminal on stream 2
MCSKIP MT,<>
MCINS %.
MCDEF SL SPACES NL AS <MCSET T1=%A1.
MCSET T2=%A2.
a + b   = %%T1.+%T2..
a - b   = %%T1.-%T2..
a * b   = %%T1.*%T2..
a / b   = %%T1./%T2..
a rem b = %%T1.-%%%T1./%T2..*%T2...
Division is truncated to the greatest integer
that does not exceed the exact result. Remainder matches
the sign of the second operand, if the signs differ.
