/*REXX program obtains some numbers from the input stream (the console), shows their sum*/
numeric digits 1000                              /*just in case the user gets  ka-razy. */
say 'enter some numbers to be summed:'           /*display a prompt message to terminal.*/
parse pull y                                     /*obtain all numbers from input stream.*/
y=space(y)
y=translate(y,'+',' ')
Interpret 's='y
say 'sum of '  many  " numbers = " s/1           /*display normalized sum s to terminal.*/
