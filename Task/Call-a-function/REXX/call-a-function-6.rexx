                /*╔════════════════════════════════════════════════════════════════════╗
                  ║ Obtaining the return value of a function.                          ║
                  ║                                                                    ║
                  ║ There are 2 ways to get the (return) value (RESULT) of a function. ║
                  ╚════════════════════════════════════════════════════════════════════╝*/

currYear= yearFunc()
say 'the current year is'  currYear

call yearFunc
say 'the current year is'  result                /*result can be RESULT, it is caseless.*/
