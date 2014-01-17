/*REXX program fixes (changes)  depreciated code tags  with  newer tags.*/
@ = '<'                                /*ensure RC doesn't get confused.*/
old.  =                                /*define a default value for OLD.*/
old.1 = @'%s>'             ;   new.1 = @'lang %s>'
old.2 = @'/%s>'            ;   new.2 = @'/lang>'
old.3 = @'code %s>'        ;   new.3 = @'lang %s>'
old.4 = @'/code>'          ;   new.4 = @'/lang>'

ifid = 'Wikisource.txt'                /* Input File IDentifier.        */
ofid = 'converted.txt'                 /*Output   "      "              */

       do  while  lines(ifid) \== 0    /*keep trunkin' until it's done. */
       _=linein(ifid)                  /*read a record from input file. */

           do j=1  while  old.j \== '' /*change old ──► new until done. */
           _=changestr(new.j,_,old.j)  /*let REXX do the heavy lifting. */
           end   /*j*/

       call lineout ofid,_             /*write the re-formatted record. */
       end   /*while lines(ifid...*/
                                       /*stick a fork in it, we're done.*/
