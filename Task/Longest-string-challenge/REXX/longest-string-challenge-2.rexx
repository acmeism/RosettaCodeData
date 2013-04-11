/*REXX pgm reads a file & prints the longest [widest] record(s)/line(s).*/
!.=''                                  /*initialize stemmed array to nul*/
fileID='LONGEST2.TXT'                  /*point to the input file.       */
signal on notready                     /*when E-O-F is reached,  jump.  */
m=0                                    /*maximum width line so far.     */

  do forever;    _=linein(fileID);    w=length(_)        /*read a line. */
  say 'input =' _                      /*display the input to terminal. */
  !.w=!.w || '0a'x || _                /*build a stemmed array element. */
  m=max(m,w)                           /*find the maximum width so far. */
  end   /*forever*/

notready:   do j=m  for m              /*handle the case of no input.   */
            say center(' longest record(s): ',79,'═')
            say substr(!.m,2)
            say center(' list end ',79,'═')
            exit                       /*stick a fork in it, we're done.*/
            end   /*j*/
