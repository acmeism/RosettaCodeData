# literal strings are called string denotations in Algol 68                                #

# string denotations start and end with a double quote character                           #
# there can be 0 or more characters between the quotes                                     #
# within the quotes, any characters allowed by the implementation can appear               #
# If an embedded double quote is required, it should appear as two double quotes           #
# e.g.:                                                                                    #
print( ( "String with an embedded "" character", newline ) );

# string denotations can appear anywhere an "expression" would be allowed, e.g.:           #
STRING x := "some text";               # string denotation used as an initial value        #
print( ( "quoted string", newline ) ); # string denotation used in a procedure call        #
print( ( "[[" + x + "]]", newline ) ); # string denotations used in an expression          #

# note that technically, a single character within double quotes is a character denotation #
# (character literal) not a string denotation, normally a character denotation will be     #
# automatically coerced to a string denotation if necessary. however it does mean that     #
# custom operators that have string parameters would also need to be defined for           #
# character parameters                                                                     #
# e.g.:                                                                                    #
OP LENGTH = ( STRING a )INT: ( UPB a - LWB a ) + 1; # returns the length of a              #
# in order to make the following print "work", we need to also define :                    #
OP LENGTH = ( CHAR a )INT: 1;  # returns the length of a, which is always 1                #
#               ---- these are string denotations -------                                  #
#               vv                     vvvv         vvvvv                                  #
print( ( LENGTH "", LENGTH "A", LENGTH "AB", LENGTH "BBC", newline ) );
#                          ^^^                                                             #
#                          this is a character denotation                                  #

# C-style escapes e.g.: \n, \", \123 are not supported                                     #
# ALGOL 68RS and algol68toc support "radix strings" where a string-denotation can be       #
# specified as e.g., hexadecimal codes:                                                    #
#    16r" 0D 0A" is carriage-return line-feed                                              #

# ALGOL 68 Genie allows string denotation to be continued across several lines             #
# if the lines end with \, the \ characters are not part of the string                     #
# NB - this is not a standard feature of Algol 68                                          #
print( ( "Hello\
, \
World\
!" ) );

# Algol 68 does not have string-interpolation                                              #
SKIP
