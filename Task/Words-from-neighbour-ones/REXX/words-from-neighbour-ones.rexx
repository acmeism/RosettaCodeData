/*REXX pgm finds words that're composed from neighbor words (within an identified dict).*/
parse arg minL iFID .                            /*obtain optional arguments from the CL*/
if minL=='' | minL=="," then minL= 9             /*Not specified?  Then use the default.*/
if iFID=='' | iFID=="," then iFID='unixdict.txt' /* "      "         "   "   "     "    */
#= 0;          @.=;                     !.= 0    /*number of usable words in dictionary.*/
            do recs=0  while lines(iFID)\==0     /*read each word in the file  (word=X).*/
            x= strip( linein( iFID) )            /*pick off a word from the input line. */
            if length(x)<minL  then iterate      /*Is the word too short?  Then skip it.*/
            #= # + 1                             /*bump the count of usable words.      */
            @.#= x;       upper x;      !.x= 1   /*original case;  create findable word.*/
            end   /*recs*/                       /* [↑]   semaphore name is uppercased. */
say copies('─', 30)        recs               "words in the dictionary file: "        iFID
say copies('─', 30)  right(#, length(recs) )  "usable words in the dictionary file."
finds= 0                                         /*count of the  changable  words found.*/
say;                             $=
        do j=1  for #;           y= left(@.j, 1) /*initialize the new word to be built. */
             do k=2  to 9  until n>#;   n= j + k /*use next 8 usable words in dictionary*/
             y= y || substr(@.n, k, 1)           /*build a new word, 1 letter at a time.*/
             end   /*k*/
        uy=y;                    upper uy        /*obtain uppercase version of the word.*/
        if \!.uy  then iterate                   /*Does the new word exist?  No, skip it*/
        if wordpos(uy, $)>0  then iterate        /*Word is a dup?  Then skip duplicate. */
        finds= finds + 1                         /*bump count of found neighboring words*/
        $= $ uy                                  /*add a word to the list of words found*/
        say right( left(y, 30), 40)              /*indent original word for readability.*/
        end      /*j*/
                                                 /*stick a fork in it,  we're all done. */
say copies('─', 30)     finds     ' neighbor words found with a minimum length of '   minL
