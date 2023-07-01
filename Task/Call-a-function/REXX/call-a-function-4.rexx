                /*╔════════════════════════════════════════════════════════════════════╗
                  ║ Calling a function with a variable number of arguments.            ║
                  ║                                                                    ║
                  ║ This situation isn't any different then the previous example.      ║
                  ║ It's up to the programmer to code how to utilize the arguments.    ║
                  ╚════════════════════════════════════════════════════════════════════╝*/

                /*╔════════════════════════════════════════════════════════════════════╗
                  ║ Calling a function with named arguments.                           ║
                  ║                                                                    ║
                  ║ REXX allows almost anything to be passed, so the following is one  ║
                  ║ way this can be accomplished.                                      ║
                  ╚════════════════════════════════════════════════════════════════════╝*/

what= parserFunc('name=Luna', "gravity=.1654", 'moon=yes')
say 'name='  common.name
gr= common.gr
say 'gravity=' gr
exit                                             /*stick a fork in it,  we're all done. */

parseFunc: procedure expose common.
                                      do j=1  for arg()
                                      parse var  arg(j)   name  '='  val
                                      upper name                         /*uppercase it.*/
                                      call value 'COMMON.'name,val
                                      end
           return arg()
