/*REXX program finds words with the largest set of anagrams (of the same size)*/
iFID='unixdict.txt'                    /*the dictionary input File IDentifier.*/
$=;  !.=;  #.=0;  ww=0;  uw=0; most=0  /*initialize a bunch of REXX variables.*/
                                       /* [↓]  read the entire file (by lines)*/
    do  while  lines(iFID)\==0         /*Got any data?   Then read a record.  */
    @=space(linein(iFID),0)            /*pick off a word from the input line. */
    LL=length(@); if LL<3 then iterate /*onesies and twosies (words) can't win*/
    if \datatype(@,'M')  then iterate  /*ignore any  non─anagramable words.   */
    uw=uw+1                            /*count of the (useable) words in file.*/
    parse upper var @ _ +1 xx '' @.    /*get uppercase  @   and nullify   @.  */
    @._=_                              /*get the first letter (special case). */
                                       /*[↓]  sort/put letters alphabetically.*/
      do LL-1;  parse var xx _ +1 xx;  @._=@._||_;   end   /*get rest of word.*/
                                       /*reassemble word with sorted letters. */
      zz=@.a||@.b||@.c||@.d||@.e||@.f||@.g||@.h||@.i||@.j||@.k||@.l||@.m||,
         @.n||@.o||@.p||@.q||@.r||@.s||@.t||@.u||@.v||@.w||@.x||@.y||@.z
    !.zz=!.zz @;   #.zz=#.zz+1         /*append it to !.zz;  bump the counter.*/
    if #.zz>most   then do; $=zz; most=#.zz;  if LL>ww  then ww=LL; iterate; end
    if #.zz==most  then     $=$ zz     /*append the sorted word──► $ anagrams.*/
    end   /*while*/
say '─────────────────────────' uw 'useable words in the dictionary file: ' iFID
say
     do m=1  for words($);       z=subword($,m,1)    /*high count of anagrams.*/
     say '     '  left(subword(!.z,1,1),ww)  '   [anagrams: '  subword(!.z,2)"]"
     end   /*m*/                       /*WW  is the maximum width of any word.*/
say
say '───── Found'  words($)   "words  (each of which have"   #.z-1  'anagrams).'
                                       /*stick a fork in it,  we're all done. */
