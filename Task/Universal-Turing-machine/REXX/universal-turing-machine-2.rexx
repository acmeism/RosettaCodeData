/*REXX pgm executes a Turing machine based on initial state, tape, rules*/
state = 'a'                            /*initial Turing machine state.  */
term  = 'halt'                         /*a state that is used for halt. */
blank = 0                              /*this character is a true blank.*/
call turing_rule  'a 0 1 right b'      /*define a rule for the machine. */
call turing_rule  'a 1 1 left  c'      /*   "   "   "   "   "     "     */
call turing_rule  'b 0 1 left  a'      /*   "   "   "   "   "     "     */
call turing_rule  'b 1 1 right b'      /*   "   "   "   "   "     "     */
call turing_rule  'c 0 1 left  b'      /*   "   "   "   "   "     "     */
call turing_rule  'c 1 1 stay  halt'   /*   "   "   "   "   "     "     */
call turing_init                       /*initialize tape to string(s).  */
call turing_machine                    /*go invoke the Turning machine. */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────TURING_MACHINE subroutine───────────*/
turing_machine ∙∙∙
