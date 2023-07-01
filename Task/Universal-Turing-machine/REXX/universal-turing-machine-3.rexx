/*REXX program executes a  Turing machine  based on   initial state,  tape, and rules.  */
state = 'A'                                      /*initialize the  Turing machine state.*/
term  = 'H'                                      /*a state that is used for the  halt.  */
blank =  0                                       /*this character is a  "true"  blank.  */
call Turing_rule  'A 0 1 right B'                /*define a rule for the Turing machine.*/
call Turing_rule  'A 1 1 left  C'                /*   "   "   "   "   "     "      "    */
call Turing_rule  'B 0 1 right C'                /*   "   "   "   "   "     "      "    */
call Turing_rule  'B 1 1 right B'                /*   "   "   "   "   "     "      "    */
call Turing_rule  'C 0 1 right D'                /*   "   "   "   "   "     "      "    */
call Turing_rule  'C 1 0 left  E'                /*   "   "   "   "   "     "      "    */
call Turing_rule  'D 0 1 left  A'                /*   "   "   "   "   "     "      "    */
call Turing_rule  'D 1 1 left  D'                /*   "   "   "   "   "     "      "    */
call Turing_rule  'E 0 1 stay  H'                /*   "   "   "   "   "     "      "    */
call Turing_rule  'E 1 0 left  A'                /*   "   "   "   "   "     "      "    */
call Turing_init                                 /*initialize the tape to some string(s)*/
call TM                                          /*go and invoke the  Turning machine.  */
exit                                             /*stick a fork in it, we're done.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
TM: ∙∙∙
