/*REXX program  reads  a file  and  displays  it to the screen  (with word wrap).       */
parse arg iFID width .                           /*obtain optional arguments from the CL*/
if  iFID=='' |  iFID==","  then  iFID='LAWS.TXT' /*Not specified?  Then use the default.*/
if width=='' | width==","  then width=linesize() /* "      "         "   "   "     "    */
@=                                               /*number of words in the file (so far).*/
            do  while lines(iFID)\==0            /*read from the file until End-Of-File.*/
            @=@ linein(iFID)                     /*get a record  (line of text).        */
            end   /*while*/
$=word(@,1)                                      /*initialize  $  with the first word.  */
            do k=2  for words(@)-1;  x=word(@,k) /*parse until text (@) exhausted.      */
            _=$ x                                /*append it to the  $  list and test.  */
            if length(_)>=width  then do;  say $ /*this word a bridge too far?    > w.  */
                                           _=x   /*assign this word to the next line.   */
                                     end
            $=_                                  /*new words (on a line)  are OK so far.*/
            end   /*m*/
if $\==''  then say $                            /*handle any residual words (overflow).*/
                                                 /*stick a fork in it,  we're all done. */
