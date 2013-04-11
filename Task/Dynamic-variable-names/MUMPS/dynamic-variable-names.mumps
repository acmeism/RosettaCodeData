USER>KILL ;Clean up workspace

USER>WRITE ;show all variables and definitions

USER>READ "Enter a variable name: ",A
Enter a variable name: GIBBERISH
USER>SET @A=3.14159

USER>WRITE

A="GIBBERISH"
GIBBERISH=3.14159
