/*REXX pgm reads a file & prints the longest [widest] record(s)/line(s).*/
!.=''                                  /*initialize stemmed array to nul*/
fileID='LONGEST1.TXT'                  /*point to the input file.       */
m=0

  do while min(lines(fileID),1);     _=linein(fileID);      w=length(_)
  say 'input =' _                      /*display the input to terminal. */
  !.w=!.w || '0a'x || _                /*build a stemmed array element. */
  m=max(m,w)                           /*find the maximum width so far. */
  end   /*while min(lines(... */

      do j=m  for m                    /*handle the case of no input.   */
      say center(' longest record(s): ',79,'═')
      say substr(!.m,2)
      say center(' list end ',79,'═')
      exit                             /*stick a fork in it, we're done.*/
      end   /*j*/
