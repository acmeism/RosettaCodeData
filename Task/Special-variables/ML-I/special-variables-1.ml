MCSKIP "WITH" NL
"" Special variables
"" There are four different kinds of variables in ML/I.
"" Permanent (P) variables - these have no special predefined values.
"" Character (C) variables - these have no special predefined values.
"" Temporary (T) variables - a macro has at least three of these, and
""    those have predefined values.
"" System (S) variables - these are for control and status. The number
""    of these is implementation dependent.
MCSKIP MT,<>
MCINS %.
MCDEF TVARDEMO , NL
AS <T-variables are local to the current macro call
T1 is the number of arguments to current macro call - value is %T1.
T2 is the number of macro calls so far - value is %T2.
T3 is the current depth of nesting - value is %T3.
>
TVARDEMO xxx,yyy

MCDEF SVARDEMO WITHS NL
AS <The first nine S-variables are implementation independent
S1 controls startline insertion - value is %S1.
S2 is the current source text line number - value is %S2.
S3 controls error messages related to warning markers - value is %S3.
S4 controls context printout after a <MCNOTE> - value is %S4.
S5 is the count of processing errors - value is %S5.
S6 enables the definition of an atom to be changed - value is %S6.
S7, S8 and S9 are currently unused.

All other S-variables have implementation defined meanings.
>
SVARDEMO
