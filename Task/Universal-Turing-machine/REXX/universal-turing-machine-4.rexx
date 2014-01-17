/*REXX pgm executes a Turing machine based on initial state, tape, rules*/
state = 'A'                            /*initial Turing machine state.  */
term  = 'halt'                         /*a state that is used for halt. */
blank = 0                              /*this character is a true blank.*/
call turing_rule  'A 1 1 right A'      /*define a rule for the machine. */
call turing_rule  'A 2 3 right B'      /*   "   "   "   "   "     "     */
call turing_rule  'A 0 0 left  E'      /*   "   "   "   "   "     "     */
call turing_rule  'B 1 1 right B'      /*   "   "   "   "   "     "     */
call turing_rule  'B 2 2 right B'      /*   "   "   "   "   "     "     */
call turing_rule  'B 0 0 left  C'      /*   "   "   "   "   "     "     */
call turing_rule  'C 1 2 left  D'      /*   "   "   "   "   "     "     */
call turing_rule  'C 2 2 left  C'      /*   "   "   "   "   "     "     */
call turing_rule  'C 3 2 left  E'      /*   "   "   "   "   "     "     */
call turing_rule  'D 1 1 left  D'      /*   "   "   "   "   "     "     */
call turing_rule  'D 2 2 left  D'      /*   "   "   "   "   "     "     */
call turing_rule  'D 3 1 right A'      /*   "   "   "   "   "     "     */
call turing_rule  'E 1 1 left  E'      /*   "   "   "   "   "     "     */
call turing_rule  'E 0 0 right halt'   /*   "   "   "   "   "     "     */
call turing_init 1 2 2 1 2 2 1 2 1 2 1 2 1 2 /*init. tape to string(s). */
call turing_machine                    /*go invoke the Turning machine. */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────TURING_MACHINE subroutine───────────*/
turing_machine ∙∙∙
