/*REXX program finds changeable words (within an identified dict.), changing any letter.*/
parse arg minL iFID .                            /*obtain optional arguments from the CL*/
if minL=='' | minL=="," then minL= 12            /*Not specified?  Then use the default.*/
if iFID=='' | iFID=="," then iFID='unixdict.txt' /* "      "         "   "   "     "    */
call readDict                                    /*read & process/filter the dictionary.*/
abc= 'abcdefghijklmnopqrstuvwxyz';   upper abc   /*alphabet ordered by frequency of use.*/
Labc= length(abc)                                /*the length of the alphabet to be used*/
finds= 0                                         /*count of the  changeable words found.*/
        do j=1  for n;          L= length($.j)   /*process all the words that were found*/
        x= $.j;                 upper x          /*get an uppercased version of the word*/

           do k=1  for L;    y= substr(x, k, 1)  /*Y:  the current letter being changed.*/
              do c=1  for Labc                   /* [↓]  change the Y letter to another.*/
              ?= substr(abc, c, 1)               /*get a new char to replace one in word*/
              if ?==y  then iterate              /*Is this the same char?  Then use next*/
              new= overlay(?, x, k);   upper new /*create a spanking new (changed) word.*/
              if @.new==''  then iterate         /*New word not in dictionary?  Skip it.*/
              finds= finds + 1                   /*bump count of changeable words found.*/
              say right(left($.j, 30), 40) @.new /*indent original word for readability.*/
              end   /*c*/
           end      /*k*/
        end         /*j*/

say copies('─', 30)    finds    ' changeable words found with a minimum length of '   minL
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
readDict:                           n=0;     @.= /*N:   the word count of usable words. */
              do #=1  while lines(iFID)\==0      /*read each word in the file  (word=X).*/
              x= strip( linein( iFID) )          /*pick off a word from the input line. */
              if length(x)<minL     then iterate /*Is the word too short?  Then skip it.*/
              if \datatype(x, 'M')  then iterate /* "  "    "  not alphabetic?  Skip it.*/
              n= n + 1;     $.n= x;              /*bump the word counter;  assign to $. */
              upper x;      @.x= $.n             /*assign uppercased word ───► array.   */
              end   /*#*/                        /* [↑]   semaphore name is uppercased. */
         #= # - 1                                /*adjust word count because of DO loop.*/
         say copies('─', 30) #  "words  ("n 'usable words)  in the dictionary file: ' iFID
         return
