/*REXX program finds the  largest  deranged word  (within an identified dictionary).    */
iFID= 'unixdict.txt';     words=0                /*input file ID; number of words so far*/
wL.=0                                            /*number of words of length  L.  so far*/
      do j=1  while lines(iFID)\==0              /*read each word in the file  (word=X).*/
      x=space( linein( iFID),  0)                /*pick off a word from the input line. */
      L=length(x);        if L<3 then iterate    /*onesies & twosies can't possible win.*/
      words= words + 1                           /*bump the count of  (useable)  words. */
      #.words=L                                  /*the length of the word found.        */
      @.words=x                                  /*save the word in an array.           */
      wL.L=wL.L+1;        _=wL.L                 /*bump counter of words of length  L.  */
      @@.L._= x                                  /*array   of words of length  L.       */
         /*sort the letters*/   do ja=1  for L;   !.ja=substr(x, ja, 1);    end  /*ja*/
      !.0=L;  call esort; z=;   do jb=1  for L;   z=z || !.jb;              end  /*jb*/
      @@s.L._= z                                 /*store the sorted word (letters).     */
      @s.words= @@s.L._                          /*store the sorted length  L  version. */
      end   /*j*/
a.=                                              /*all the  anagrams  for word  X.      */
say copies('─', 30)   words   'words in the dictionary file: '    iFID
m=0;               n.=0                          /*# anagrams for word  X;   m=max L.   */
       do j=1  for words                         /*process usable words that were found.*/
       x=@.j;     Lx=#.j;   xs=@s.j              /*get some vital statistics for  X     */
       if m\==0 & Lx<m then iterate              /*bypass comparisons if too short.     */
         do k=1  for wL.Lx                       /*process all the words of length  L.  */
         if xs\== @@s.Lx.k  then iterate         /*is this a true anagram of  X ?       */
         if x  == @@.Lx.k   then iterate         /*skip of processing anagram on itself.*/
            do c=1  for Lx                       /*ensure no character position shared. */
            if substr(@.j, c, 1) == substr(@@.Lx.k, c, 1)  then iterate k
            end      /*c*/
         n.j= n.j + 1;     a.j= a.j   @@.Lx.k    /*bump counter;  then add ──► anagrams.*/
         m= max(m, Lx)                           /*M  is the maximum length of a word.  */
         end         /*k*/
       end           /*j*/

  do k=1  for words                              /*now, search all words for the maximum*/
  if #.k==m   then if n.k\==0   then if word(a.k, 1) > @.k  then say  @.k  a.k
  end   /*k*/                                    /* [↑]  REXX has no short-circuits.    */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
esort: procedure expose !.; h=!.0;   do while h>1; h=h%2;   do i=1  for !.0-h;  j=i; k=h+i
         do while !.k<!.j;  t=!.j;  !.j=!.k;  !.k=t;   if h>=j  then leave;  j=j-h;  k=k-h
         end   /*while !.k<!.j*/;         end  /*i*/;         end  /*while h>1*/;   return
