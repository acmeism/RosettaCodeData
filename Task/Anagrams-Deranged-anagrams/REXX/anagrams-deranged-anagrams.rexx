/*REXX program finds the  largest  deranged word  (within an identified dictionary).    */
iFID= 'unixdict.txt';     words=0                /*input file ID; number of words so far*/
wL.=0                                            /*number of words of length  L.  so far*/
      do while lines(iFID)\==0                   /*read each word in the file  (word=X).*/
      x= strip( linein( iFID) )                  /*pick off a word from the input line. */
      L= length(x);       if L<3 then iterate    /*onesies & twosies can't possible win.*/
      words= words + 1                           /*bump the count of  (usable)  words.  */
      #.words= L                                 /*the length of the word found.        */
      @.words= x                                 /*save the word in an array.           */
      wL.L= wL.L+1;       _= wL.L                /*bump counter of words of length  L.  */
      @@.L._= x                                  /*array   of words of length  L.       */
                                  do i=1  while x\=='';  parse var x !.i +1 x;  end  /*i*/
      call eSort L;       z=;     do j=1  for L;         z= z || !.j;           end  /*j*/
      @@s.L._= z                                 /*store the sorted word (letters).     */
      @s.words= @@s.L._                          /*store the sorted length  L  version. */
      end   /*while*/
a.=                                              /*all the  anagrams  for word  X.      */
say copies('─', 30)   words   'usable words in the dictionary file: '     iFID
m= 0;              n.= 0                         /*# anagrams for word  X;   m=max L.   */
       do j=1  for words                         /*process usable words that were found.*/
       Lx= #.j;   if Lx<m  then iterate          /*get length of word; skip if too short*/
       x= @.j;    xs= @s.j                       /*get some vital statistics for  X     */
           do k=1  for wL.Lx                     /*process all the words of length  L.  */
           if xs\== @@s.Lx.k  then iterate       /*is this not a true anagram of  X ?   */
           if x  ==  @@.Lx.k  then iterate       /*skip of processing anagram on itself.*/
                do c=1  for Lx                   /*ensure no character position shared. */
                if substr(@.j, c, 1) == substr(@@.Lx.k, c, 1)  then iterate k
                end   /*c*/                      /* [+]  now compare the rest of chars. */
           n.j= n.j + 1;     a.j= a.j   @@.Lx.k  /*bump counter;  then add ──► anagrams.*/
           m= max(m, Lx)                         /*M  is the maximum length of a word.  */
           end        /*k*/
       end            /*j*/

   do k=1  for words                             /*now, search all words for the maximum*/
   if #.k==m   then if n.k\==0   then if word(a.k, 1) > @.k  then say  @.k  a.k
   end   /*k*/                                   /* [↑]  REXX has no short-circuits.    */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
eSort: procedure expose !.;  parse arg ho 1 h    /*obtain number of elements; also copy.*/
         do while h>1;      h=h % 2;                    do i=1  for ho-h;   j= i;   k= h+i
         do while !.k<!.j;  t=!.j;  !.j=!.k;  !.k=t;   if h>=j  then leave;  j=j-h;  k=k-h
         end   /*while !.k···*/;         end  /*i*/;         end  /*while h>1*/;    return
