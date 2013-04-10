/*REXX program finds the  largest  deranged word  (within a dictionary).*/
ifid='unixdict.txt';    words=0        /*input file identifier, # words.*/
wL.=0                                  /*number of words of length  L.  */
      do j=1  while lines(ifid)\==0    /*read each word in file (word=X)*/
      x=space(linein(ifid),0)          /*pick off a word from the input.*/
      L=length(x); if L<3 then iterate /*onesies and twosies can't win. */
      words=words+1                    /*count of (useable) words.      */
      #.words=L                        /*the length of the word found.  */
      @.words=x                        /*save the word in an array.     */
      wL.L=wL.L+1;        _=wL.L       /*counter of words of length  L. */
      @@.L._=x                         /*array   of words of length  L. */
         /*sort the letters*/   do ja=1 for L;   !.ja=substr(x,ja,1);  end
      !.0=L; call esort;z=;     do jb=1 for L;   z=z || !.jb;          end
      @@s.L._=z                        /*store the sorted word (letters)*/
      @s.words=@@s.L._                 /*and also, sorted length L vers.*/
      end   /*j*/
a.=                                    /*all the anagrams for word  X.  */
say copies('─',30) words 'words in the dictionary file: ' ifid
m=0; n.=0                              /*# anagrams for word X; m=max L.*/
       do j=1  for words               /*process the usable words found.*/
       x=@.j;     Lx=#.j;   xs=@s.j    /*get some vital statistics for X*/
       if m\==0 & Lx<m then iterate    /*bypass comparisons if too short*/
         do k=1  for wL.Lx             /*process all the words of len L.*/
         if xs\==@@s.Lx.k then iterate /*is this a true anagram of  X ? */
         if x  ==@@.Lx.k  then iterate /*skip doing anagram on itself.  */
            do c=1 for Lx              /*ensure no character pos shared.*/
            if substr(@.j,c,1)==substr(@@.Lx.k,c,1)  then iterate k
            end      /*c*/
         n.j=n.j+1;  a.j=a.j  @@.Lx.k  /*bump counter, add ──► anagrams.*/
         m=max(m,Lx)                   /*M is the maximum length of word*/
         end         /*k*/
       end           /*j*/

  do k=1  for words                    /*now, search all words for max. */
  if #.k==m   then if n.k\==0   then if word(a.k,1)>@.k   then say @.k a.k
  end   /*k*/                          /*above:REXX has no shortcircuits*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ESORT───────────────────────────────*/
esort:procedure expose !.;h=!.0;do while h>1;h=h%2;do i=1 for !.0-h;j=i;k=h+i
do while !.k<!.j;t=!.j;!.j=!.k;!.k=t;if h>=j then leave;j=j-h;k=k-h;end;end;end;return
