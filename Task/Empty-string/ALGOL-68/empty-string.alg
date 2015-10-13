# declare a string variable and assign an empty string to it                  #
STRING s := "";

# test the string is empty                                                    #
IF s = "" THEN write( ( "s is empty", newline ) ) FI;

# test the string is not empty                                                #
IF s /= "" THEN write( ( "s is not empty", newline ) ) FI;

# as a string is an array of characters, we could also test for emptyness by  #
# checking for lower bound > upper bound                                      #
IF LWB s > UPB s THEN write( ( "s is still empty", newline ) ) FI
