# floating point literals are called REAL denotations in Algol 68      #
# They have the following forms:                                       #
#     1: a digit sequence followed by "." followed by a digit sequence #
#     2: a "." followed by a digit sequence                            #
#     3: forms 1 or 2 followed by "e" followed by an optional sign     #
#                     followed by a digit sequence                     #
#     4: a digit sequence follows by "e" followed by an optional sign  #
#                     followed by a digit sequence                     #
#                                                                      #
# The "e" indicates the following optionally-signed digit sequence is  #
# the exponent of the literal.                                         #
# If the implementation allows, a "times ten to the power symbol"      #
# can be used to replace "e" - e.g. a subscript "10" character         #
#                                                                      #
# spaces can appear anywhere in the denotation                         #
# Examples:                                                            #
REAL r;
r := 1.234;
r :=  .987;
r := 4.2e-9;
r := .4e+23;
r := 1e10;
r := 3.142e-23;
r := 1 234 567 .      9           e -                  4;
