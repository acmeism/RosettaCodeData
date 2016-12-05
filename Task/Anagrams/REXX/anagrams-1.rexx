/*REXX program  finds words  with the  largest set of  anagrams  (of the same size).    */
iFID= 'unixdict.txt'                             /*the dictionary input File IDentifier.*/
$=;    !.=;    #.=0;    w=0;    uw=0;    most=0  /*initialize a bunch of REXX variables.*/
                                                 /* [↓]  read the entire file (by lines)*/
    do  while  lines(iFID)\==0                   /*Got any data?   Then read a record.  */
    @=space( linein(iFID), 0)                    /*pick off a word from the input line. */
    L=length(@);  if L<3  then iterate           /*onesies and twosies words can't win. */
    if \datatype(@, 'M')  then iterate           /*ignore any  non─anagramable words.   */
    uw=uw+1                                      /*count of the (useable) words in file.*/
    z=sortA(@)                                   /*sort the letters in the word.        */
    !.z=!.z @;            #.z=#.z+1              /*append it to !.z;  bump the counter. */
    if #.z>most  then do; $=z;  most=#.z;  if L>w  then w=L;     iterate;    end
    if #.z==most then     $=$ z                  /*append the sorted word──► max anagram*/
    end   /*while*/                              /*$ ◄── list of high count anagrams.   */
say '─────────────────────────'    uw    "useable words in the dictionary file: "     iFID
say
     do m=1  for words($);   z=subword($, m, 1)  /*the high count of the anagrams.      */
     say '     '   left(subword(!.z, 1, 1),  w)   '   [anagrams: '  subword(!.z, 2)"]"
     end   /*m*/                                 /*W   is the maximum width of any word.*/
say
say '───── Found'     words($)     "words  (each of which have"     #.z-1     'anagrams).'
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
sortA: procedure; arg char +1 xx,@.              /*get the first letter of arg;  @.=null*/
       @.char=char                               /*no need to concatenate the first char*/
                                                 /*[↓]  sort/put letters alphabetically.*/
                 do length(xx);   parse var xx char +1 xx;   @.char=@.char || char;    end
                                                 /*reassemble word with sorted letters. */
       return @.a||@.b||@.c||@.d||@.e||@.f||@.g||@.h||@.i||@.j||@.k||@.l||@.m||,
              @.n||@.o||@.p||@.q||@.r||@.s||@.t||@.u||@.v||@.w||@.x||@.y||@.z
