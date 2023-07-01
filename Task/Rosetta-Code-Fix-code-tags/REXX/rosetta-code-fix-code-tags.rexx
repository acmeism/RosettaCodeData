/*REXX program  fixes (changes)  depreciated  HTML  code tags  with  newer tags.        */
@="<";  old.=;        old.1 = @'%s>'         ;     new.1 = @"lang %s>"
                      old.2 = @'/%s>'        ;     new.2 = @"/lang>"
                      old.3 = @'code %s>'    ;     new.3 = @"lang %s>"
                      old.4 = @'/code>'      ;     new.4 = @"/lang>"

iFID = 'Wikisource.txt'                          /*the  Input File  IDentifier.         */
oFID = 'converted.txt'                           /*the Output   "      "                */

  do  while lines(iFID)\==0                      /*keep reading the file until finished.*/
  $= linein(iFID)                                /*read a record from the input file.   */
                     do j=1  while old.j \== ''  /*change old ──► new  until  finished. */
                     $= changestr(old.j,$,new.j) /*let REXX do the heavy lifting.       */
                     end   /*j*/
  call lineout oFID,$                            /*write re-formatted record to output. */
  end   /*while*/                                /*stick a fork in it,  we're all done. */
