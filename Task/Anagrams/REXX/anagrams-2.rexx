/*REXX program finds words with the largest set of anagrams (same size).*/
iFID='unixdict.txt'                    /*input file identifier, # words.*/
hc=; !.=;  #.=0;  w=0; words=0; most=0 /*initialize some REXX variables.*/
                                       /* [↓]  read entire file by line.*/
     do recs=0  while  lines(iFID)\==0 /*Got data?   Then read a record.*/
     x=space(linein(iFID),0)           /*pick off a word from the input.*/
     L=length(x); if L<3  then iterate /*onesies and twosies can't win. */
     if \datatype(x,'M')  then iterate /*filter out nonanagramable words*/
     words=words+1                     /*count of (useable) words.      */
     parse upper var x y +1 u _.       /*get uppercase X & nullify "_." */
     xx='?'y;  _.xx=y                  /*get 1st letter  (special case).*/
                                       /*[↓] put letters alphabetically.*/
       do length(u);  parse var u y +1 u;   xx='?'y;   _.xx=_.xx||y;   end
                                       /*reassemble word, sorted letters*/
     z=_.?a||_.?b||_.?c||_.?d||_.?e||_.?f||_.?g||_.?h||_.?i||_.?j||_.?k||_.?l||_.?m||,
       _.?n||_.?o||_.?p||_.?q||_.?r||_.?s||_.?t||_.?u||_.?v||_.?w||_.?x||_.?y||_.?z
     !.z=!.z x;            #.z=#.z+1   /*append it to !.z, bump the ctr.*/
     if #.z>most  then do; hc=z;  most=#.z;  if L>w then w=L; iterate; end
     if #.z==most then     hc=hc z     /*append sorted word─►hc anagrams*/
     end   /*recs*/                    /*hc◄─list of high count anagrams*/
say '──────────────────────────────'  recs  'words in the dictionary file: '  iFID
say
     do m=1  for words(hc);      z=subword(hc,m,1) /*high count anagrams*/
     say '     '  left(subword(!.z,1,1),w)   '   [anagrams: '   subword(!.z,2)"]"
     end   /*m*/                       /* W  is the maximum width word. */
say
say '───── Found'   words(hc)   "words  (each of which have"   #.z-1   'anagrams).'
                                       /*stick a fork in it, we're done.*/
