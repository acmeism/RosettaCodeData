                /*╔════════════════════════════════════════════════════════════════════╗
                  ║ Calling a function in statement context.                           ║
                  ║                                                                    ║
                  ║ REXX allows functions to be called (invoked) two ways,  the first  ║
                  ║ example (above) is calling a function in statement context.        ║
                  ╚════════════════════════════════════════════════════════════════════╝*/

                /*╔════════════════════════════════════════════════════════════════════╗
                  ║ Calling a function in within an expression.                        ║
                  ║                                                                    ║
                  ║ This is a variant of the first example.                            ║
                  ╚════════════════════════════════════════════════════════════════════╝*/

yr= yearFunc() + 20
say 'two decades from now, the year will be:' yr
exit                                             /*stick a fork in it,  we're all done. */
