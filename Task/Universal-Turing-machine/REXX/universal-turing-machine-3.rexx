/*REXX pgm executes a Turing machine based on initial state, tape, rules*/
state = 'A'                            /*initial Turing machine state.  */
term  = 'H'                            /*a state that is used for halt. */
blank = 0                              /*this character is a true blank.*/
call turing_rule  'A 0 1 right B'      /*define a rule for the machine. */
call turing_rule  'A 1 1 left  C'      /*   "   "   "   "   "     "     */
call turing_rule  'B 0 1 right C'      /*   "   "   "   "   "     "     */
call turing_rule  'B 1 1 right B'      /*   "   "   "   "   "     "     */
call turing_rule  'C 0 1 right D'      /*   "   "   "   "   "     "     */
call turing_rule  'C 1 1 left  E'      /*   "   "   "   "   "     "     */
call turing_rule  'D 0 1 left  A'      /*   "   "   "   "   "     "     */
call turing_rule  'D 1 1 left  D'      /*   "   "   "   "   "     "     */
call turing_rule  'E 0 1 stay  H'      /*   "   "   "   "   "     "     */
call turing_rule  'E 1 1 left  A'      /*   "   "   "   "   "     "     */
call turing_init                       /*initialize tape to string(s).  */
call turing_machine                    /*go invoke the Turning machine. */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────TURING_MACHINE subroutine───────────*/
turing_machine ∙∙∙
