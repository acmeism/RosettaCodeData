/*REXX program demonstrates a (query)  decision table  and  possible corrective actions.*/
                      Q.=;           Q.1 = 'Does the printer not print?'
                                     Q.2 = 'Is there a red light flashing on the printer?'
                                     Q.3 = 'Is the printer unrecognized by the software?'
                                     Q.0 = 3     /*the number of questions to be asked. */
action.=            /* Y=yes       N=no        if character isn't a letter = don't care.*/

      /*    ┌─────◄── answer to 1st question     (it can be in upper\lower\mixed case). */
      /*    │┌────◄──   "     " 2nd    "           "  "   "  "   "     "     "     "    */
      /*    ││┌───◄──   "     " 3rd    "           "  "   "  "   "     "     "     "    */
      /*    │││                                                                         */
      /*    ↓↓↓                                                                         */
action.1 = 'yny'  ;         pos.1 = "═════════  Check the power cable."
action.2 = 'y.y'  ;         pos.2 = "═════════  check the printer-computer cable."
action.3 = '..y'  ;         pos.3 = "═════════  Ensure printer software is installed."
action.4 = '.y.'  ;         pos.4 = "═════════  Check/replace ink."
action.5 = 'y.n'  ;         pos.5 = "═════════  Check for paper jam."

      do i=1  while Q.i\=='';   ans.i= asker(i)  /*display the question, obtain response*/
      end   /*i*/
say                                              /*display a blank line before questions*/
possible= 0                                      /*we'll be counting possible solutions.*/

  do k=1  while action.k\==''                    /*filter the answers via decision table*/

                do j=1;      d= substr(action.k, j, 1);            upper d
                jm= j//Q.0;  if jm==0  then jm= Q.0
                if d==' '              then leave
                if \datatype(d, 'U')   then iterate
                if d\==ans.jm          then iterate k
                end   /*j*/
  say pos.k                                      /*this could be a possible solution.   */
  possible= possible + 1                         /*count number of possible solutions.  */
  end       /*k*/

if possible==0  then say '═════════  There are no solutions for the information supplied.'
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
asker:  arg ?;   oops= 0;       Qprefix= copies('─', 9)   '(question'   ?   "of"   Q.0') '
howTo = '(You can answer with a  Yes or No        [or  Quit])'

  do forever
  if oops  then do;   say;   say right(howTo, 79);    say;   oops= 0
                end
  say Qprefix Q.?;           parse pull x                  /*ask question (after prompt)*/
  x= strip(space(x), , .);   parse upper var  x   u 1 u1 2 /*u1=1st character of answer.*/
  if words(x)==0          then iterate                     /*Nothing entered? Try again.*/
  if abbrev('QUIT', u,1)  then exit                        /*user is tired of answering.*/
  if (abbrev('YES', u)   |   abbrev("NO", u))   &   words(x)==1  then return u1
  say 'invalid response: '   x;           oops= 1
  end   /*forever*/
