                /*╔════════════════════════════════════════════════════════════════════╗
                  ║ Calling a function with a fixed number of arguments.               ║
                  ║                                                                    ║
                  ║ I take this to mean that the function requires a fixed number of   ║
                  ║ arguments.   As above, REXX doesn't enforce calling (or invoking)  ║
                  ║ a (any) function with a certain number of arguments,  but the      ║
                  ║ programmer can check if the correct number of arguments have been  ║
                  ║ specified (or not).                                                ║
                  ║ In some languages, these are known as  "generic"  functions.       ║
                  ╚════════════════════════════════════════════════════════════════════╝*/

ggg= FourFunc(12, abc, 6+q, zz%2, 'da 5th disagreement')
say 'ggg squared='  ggg**2
exit                                             /*stick a fork in it,  we're all done. */

FourFunc: procedure; parse arg a1,a2,a3          /*obtain the first  three  arguments.  */
          a4= arg(4)                             /*another way to obtain the  4th  arg. */
          errmsg= '***error***'                  /*an error message eyecatcher string.  */
          if arg() \== 4  then do
                               say err  "FourFunc function requires 4 arguments,"
                               say err  "but instead it found" arg() 'arguments.'
                               exit 13                   /*exit function with a RC of 13*/
                               end

          return a1 + a2 + a3 + a4
