/*REXX program finds the minimum length abbreviation for a lists of words (from a file).*/
parse arg uw                                     /*obtain optional arguments from the CL*/
iFID= 'ABBREV_A.TAB'                             /*name of the file that has the table. */
say 'minimum'                                    /*display the first part of the title. */
say 'abbrev' center("days of the week", 80)      /*display the title for the output.    */
say '══════' center("",                 80, '═') /*display separator for the title line.*/
                                                 /* [↓]  process the file until done.   */
     do while lines(iFID)\==0; days=linein(iFID) /*read a line (should contain 7 words).*/
     minLen= abb(days)                           /*find the minimum abbreviation length.*/
     say right(minLen, 4)   '  '    days         /*display a somewhat formatted output. */
     end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
abb: procedure;  parse arg x;  #=words(x)        /*obtain list of words;  find how many.*/
     if #==0  then return ''                     /*check for a blank line or null line. */
     @.=                                         /*@.   is a stemmed array of the words.*/
     L=0                                         /*L    is the max length  of  "    "   */
        do j=1  for #;         @.j=word(x, j)    /*assign to array for faster processing*/
        L.j=length(@.j);       L= max(L, L.j)    /*find the maximum length of any item. */
        end   /*L*/
                                                 /* [↓]  determine minimum abbrev length*/
        do m=1  for L;         $=                /*for all lengths, find a unique abbrev*/
             do k=1  to #;     a=left(@.k, m)    /*get an abbreviation (with length  M).*/
             if wordpos(a,$)\==0  then iterate M /*test this abbreviation for uniquness.*/
             $=$  a                              /*so far, it's unique; add to the list.*/
             end   /*k*/
        leave m                                  /*a good abbreviation length was found.*/
        end        /*m*/
     return m
