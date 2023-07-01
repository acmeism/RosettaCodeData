# Operators are shown in decreasing order of precedence.
# A blank line separates groups of operators with equal precedence.
# All operators are left associative except:
# . assignment operators
# . conditional operator
# . exponentiation
# which are right associative.
#
#   ( )  grouping
#
#   $    field reference
#
#   ++   increment (both prefix and postfix)
#   --   decrement (both prefix and postfix)
#
#   ^    exponentiation
#   **   exponentiation (not all awk's)
#
#   +    unary plus
#   -    unary minus
#   !    logical NOT
#
#   *    multiply
#   /    divide
#   %    modulus
#
#   +    add
#   -    subtract
#
#        string concatenation has no explicit operator
#
#   <    relational: less than
#   <=   relational: less than or equal to
#   >    relational: greater than
#   >=   relational: greater than or equal to
#   !=   relational: not equal to
#   ==   relational: equal to
#   >    redirection: output to file
#   >>   redirection: append output to file
#   |    redirection: pipe
#   |&   redirection: coprocess (not all awk's)
#
#   ~    regular expression: match
#   !~   regular expression: negated match
#
#   in   array membership
#
#   &&   logical AND
#
#   ||   logical OR
#
#   ?:   conditional expression
#
#   =    assignment
#   +=   addition assignment
#   -=   subtraction assignment
#   *=   multiplication assignment
#   /=   division assignment
#   %=   modulo assignment
#   ^=   exponentiation assignment
#   **=  exponentiation assignment (not all awk's)
