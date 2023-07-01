/*REXX program  finds words  with the  largest set of  anagrams  (of the same size).    */
iFID= 'unixdict.txt'                             /*the dictionary input File IDentifier.*/
$=;     !.=;      ww=0;       uw=0;      most=0  /*initialize a bunch of REXX variables.*/
                                                 /* [↓]  read the entire file (by lines)*/
    do  while lines(iFID) \== 0                  /*Got any data?   Then read a record.  */
    parse value  linein(iFID)  with  @ .         /*obtain a word from an input line.    */
    len=length(@);  if len<3  then iterate       /*onesies and twosies words can't win. */
    if \datatype(@, 'M')      then iterate       /*ignore any  non─anagramable words.   */
    uw=uw + 1                                    /*count of the (useable) words in file.*/
    _=sortA(@)                                   /*sort the letters in the word.        */
    !._=!._ @;       #=words(!._)                /*append it to !._;  bump the counter. */
    if #==most  then $=$ _                       /*append the sorted word──► max anagram*/
                else if #>most  then do;   $=_;   most=#;   if len>ww  then ww=len;    end
    end   /*while*/                              /*$ ◄── list of high count anagrams.   */
say '─────────────────────────'    uw     "usable words in the dictionary file: "     iFID
say
     do m=1  for words($);   z=subword($, m, 1)  /*the high count of the anagrams.      */
     say '     '     left(word(!.z, 1),  ww)      '   [anagrams: '      subword(!.z, 2)"]"
     end   /*m*/                                 /*W   is the maximum width of any word.*/
say
say '───── Found'   words($)    "words  (each of which have"    words(!.z)-1  'anagrams).'
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
sortA: arg char 2 xx,@.                          /*get the first letter of arg;  @.=null*/
       @.char=char                               /*no need to concatenate the first char*/
                                                 /*[↓]  sort/put letters alphabetically.*/
                 do length(xx);   parse var xx char 2 xx;    @.char=@.char || char;    end
                                                 /*reassemble word with sorted letters. */
       return @.a || @.b || @.c || @.d || @.e || @.f||@.g||@.h||@.i||@.j||@.k||@.l||@.m||,
              @.n || @.o || @.p || @.q || @.r || @.s||@.t||@.u||@.v||@.w||@.x||@.y||@.z
