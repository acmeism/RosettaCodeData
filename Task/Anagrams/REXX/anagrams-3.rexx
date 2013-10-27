/*REXX program finds words with the largest set of anagrams (same size).*/
iFID='unixdict.txt'                    /*input file identifier, # words.*/
hc=; !.=;  #.=0; ww=0; words=0; most=0 /*initialize some REXX variables.*/
                                       /* [↓]  read entire file by line.*/
   do recs=0  while  lines(iFID)\==0   /*Got data?   Then read a record.*/
   @=space(linein(iFID),0)             /*pick off a word from the input.*/
   LL=length(@); if LL<3  then iterate /*onesies and twosies can't win. */
   if \datatype(@,'M')    then iterate /*exclude non-anagramable words. */
   words=words+1                       /*count of (useable) words.      */
   parse upper var @ _ +1 xx _.        /*get uppercase @ & nullify "_." */
   _._=_                               /*get 1st letter  (special case).*/
                                       /*[↓] put letters alphabetically.*/
     do LL-1;  parse var xx _ +1 xx;   _._=_._||_;   end /*rest of word.*/
                                       /*reassemble word, sorted letters*/
   zz=_.a||_.b||_.c||_.d||_.e||_.f||_.g||_.h||_.i||_.j||_.k||_.l||_.m||,
           _.n||_.o||_.p||_.q||_.r||_.s||_.t||_.u||_.v||_.w||_.x||_.y||_.z
   !.zz=!.zz @;   #.zz=#.zz+1          /*append it to !.zz, bump the ctr.*/
   if #.zz>most   then do; hc=zz;  most=#.zz;  if LL>ww then ww=LL; iterate; end
   if #.zz==most  then     hc=hc zz    /*append sorted word─►hc anagrams*/
   end   /*recs*/                      /*this loop can't have 1-letter vars.*/
say '──────────────────────────────'  recs  'words in the dictionary file: '  iFID
say
     do m=1  for words(hc);      z=subword(hc,m,1) /*high count anagrams*/
     say '     '  left(subword(!.z,1,1),ww)   '   [anagrams: '   subword(!.z,2)"]"
     end   /*m*/                       /* WW is the maximum width word. */
say
say '───── Found'   words(hc)   "words  (each of which have"   #.z-1   'anagrams).'
                                       /*stick a fork in it, we're done.*/
