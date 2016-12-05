/*REXX program obtains two numbers from the input stream (the console), shows their sum.*/
numeric digits 300                               /*the default is  nine  decimal digits.*/
parse pull a b                                   /*obtain two numbers from input stream.*/
z= (a+b) / 1                                     /*add and normalize sum, store it in Z.*/
say z                                            /*display normalized sum Z to terminal.*/
                                                 /*stick a fork in it,  we're all done. */
