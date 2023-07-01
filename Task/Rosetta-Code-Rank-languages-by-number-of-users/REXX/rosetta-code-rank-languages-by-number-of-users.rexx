/*REXX program reads 2 files & displays a ranked list of Rosetta Code languages by users*/
parse arg catFID lanFID outFID .                 /*obtain optional arguments from the CL*/
call init                                        /*initialize some  REXX  variables.    */
call get                                         /*obtain data from two separate files. */
call eSort #,0                                   /*sort languages along with members.   */
call tSort                                       /*  "      "     that are tied in rank.*/
call eSort #,1                                   /*  "      "     along with members.   */
call out                                         /*create the RC_USER.OUT (output) file.*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg _;   do jc=length(_)-3  to 1  by -3; _= insert(",",_,jc); end;  return _
s:      if arg(1)==1  then return arg(3);      return word(arg(2) 's',1)   /*pluralizer.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
eSort: procedure expose #. @. !tr.;    arg N,p2;     h= N      /*sort: number of members*/
            do     while  h>1;         h= h % 2                /*halve number of records*/
              do i=1  for N-h;         j= i;         k= h + i  /*sort this part of list.*/
              if p2  then do  while !tR.k==!tR.j  &  @.k>@.j   /*this uses a hard swap ↓*/
                          @= @.j;  #= !tR.j;  @.j= @.k;  !tR.j= !tR.k;   @.k= @;  !tR.k= #
                          if h>=j  then leave;               j= j - h;     k= k - h
                          end   /*while !tR.k==···*/
                     else do  while #.k<#.j                    /*this uses a hard swap ↓*/
                          @= @.j;  #= #.j;    @.j= @.k;    #.j= #.k;     @.k= @;    #.k= #
                          if h>=j  then leave;               j= j - h;     k= k - h
                          end   /*while #.k<···*/
              end               /*i*/           /*hard swaps needed for embedded blanks.*/
            end                 /*while h>1*/;               return
/*──────────────────────────────────────────────────────────────────────────────────────*/
get: langs= 0;           call rdr 'languages'    /*assign languages  ───►  L.ααα        */
                         call rdr 'categories'   /*append categories ───► catHeap       */
     #= 0
           do j=1  until  catHeap==''            /*process the heap of categories.      */
           parse var catHeap cat.j (sep) catHeap /*get a category from the  catHeap.    */
           parse var cat.j  cat.j '<' "(" mems . /*untangle the strange─looking string. */
           cat.j= space(cat.j); ?=cat.j; upper ? /*remove any superfluous blanks.       */
           if ?=='' | \L.?          then iterate /*it's blank  or  it's not a language. */
           if pos(',', mems)\==0    then mems= space(translate(mems,,","), 0) /*¬commas.*/
           if \datatype(mems, 'W')  then iterate /*is the "members" number not numeric? */
           #.0= #.0 + mems                       /*bump the number of  members  found.  */
           if u.?\==0  then do;     do f=1  for #  until ?==@u.f
                                    end   /*f*/
                            #.f= #.f + mems; iterate j   /*languages in different cases.*/
                            end                  /* [↑]  handle any possible duplicates.*/
           u.?= u.? + 1;       #= # + 1          /*bump a couple of counters.           */
           #.#= #.# + mems;  @.#= cat.j;  @u.#=? /*bump the counter;  assign it (upper).*/
           end   /*j*/

     !.=;        @tno= '(total) number of'       /*array holds indication of TIED langs.*/
     call tell right(commas(#),    9) @tno 'languages detected in the category file'
     call tell right(commas(langs),9) '   "       "    "     "         "     "  "  language   "'
     call tell right(commas(#.0),  9) @tno 'entries (users of lanugages) detected', , 1
     term= 0
     return                                      /*don't show any more msgs──►term. [↑] */
/*──────────────────────────────────────────────────────────────────────────────────────*/
init: sep= '█';  L.=0;  #.=0;  u.=#.;  catHeap=;  term=1;  old.= /*assign some REXX vars*/
      if catFID==''  then catFID= "RC_USER.CAT"  /*Not specified?  Then use the default.*/
      if lanFID==''  then lanFID= "RC_USER.LAN"  /* "      "         "   "   "     "    */
      if outFID==''  then outFID= "RC_USER.OUT"  /* "      "         "   "   "     "    */
      call tell center('timestamp: '  date()  time("Civil"),79,'═'), 2, 1;      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
out:  w= length( commas(#) );     rank= 0        /* [↓]  show by ascending rank of lang.*/
          do t=#  by -1  for #;   rank= rank + 1 /*bump rank of a programming language. */
          call tell   right('rank:'    right(commas(!tR.t), w),  20-1)      right(!.t, 7),
                      right('('commas(#.t)  left("entr"s(#.t, 'ies', "y")')', 9), 20)  @.t
          end   /*#*/                            /* [↑]   S(···)   pluralizes a word.   */
      call tell left('', 27)  "☼  end─of─list.  ☼", 1, 2;      return    /*bottom title.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
rdr:  arg which 2;        igAst= 1               /*ARG uppers WHICH, obtain the 1st char*/
      if which=='L'  then inFID= lanFID          /*use this fileID for the  languages.  */
      if which=='C'  then inFID= catFID          /* "    "     "    "   "   categories. */
      Uyir=  'α«ëα«»α«┐α«░α»ì/Uyir'              /*Unicode (in text)  name for  Uyir    */
      old.0= '╬£C++'     ;    new.0= "µC++"      /*Unicode ╬£C++  ───► ASCII─8: µC++    */
      old.1= 'UC++'      ;    new.1= "µC++"      /*old      UC++  ───► ASCII─8: µC++    */
      old.2= '╨£╨Ü-'     ;    new.2= "MK-"       /*Unicode ╨£╨Ü─  ───► ASCII-8: MK-     */
      old.3= 'D├⌐j├á'    ;    new.3= "Déjà"      /*Unicode ├⌐j├á  ───► ASCII─8: Déjà    */
      old.4= 'Cach├⌐'    ;    new.4= "Caché"     /*Unicode Cach├⌐ ───► ASCII─8: Caché   */
      old.5= '??-61/52'  ;    new.5= "MK-61/52"  /*somewhere past, a mis─translated: MK-*/
      old.6= 'F┼ìrmul├ª' ;    new.6= 'Fôrmulæ'   /*Unicode        ───► ASCII─8: Fôrmulæ */
      old.7= '╨£iniZinc' ;    new.7= 'MiniZinc'  /*Unicode        ───► ASCII─8: MiniZinc*/
      old.8=  Uyir       ;    new.8= 'Uyir'      /*Unicode        ───► ASCII─8: Uyir    */
      old.9= 'Perl 6'    ;    new.9= 'Raku'      /* (old name)    ───► (new name)       */

        do recs=0   while  lines(inFID) \== 0    /*read a file, a single line at a time.*/
        $= translate( linein(inFID), , '9'x)     /*handle any stray  TAB  ('09'x) chars.*/
        $$= space($);   if $$==''  then iterate  /*ignore all blank lines in the file(s)*/
                do v=0  while old.v \== ''       /*translate Unicode variations of langs*/
                if pos(old.v, $$) \==0  then $$= changestr(old.v, $$, new.v)
                end   /*v*/                      /* [↑]  handle different lang spellings*/
        if igAst  then do;  igAst= pos(' * ', $)==0;      if igAst  then iterate;      end
        if pos('RETRIEVED FROM', translate($$))\==0  then leave   /*pseudo End─Of─Data?.*/
        if which=='L'  then do;  if left($$, 1)\=="*"  then iterate  /*lang ¬legitimate?*/
                                 parse upper var   $$   '*'  $$  "<";    $$= space($$)
                                 if $$==''  then iterate
                                 $$= $$ 'USER'
                                 L.$$= 1
                                 langs= langs + 1     /*bump # of languages/users found.*/
                                 iterate
                            end                  /* [↓]  extract computer language name.*/
        if left($$, 1)=='*'  then $$= sep  ||  space( substr($$, 2) )
        catHeap= catHeap  $$                     /*append to the catHeap (CATegory) heap*/
        end   /*recs*/
      call  tell   right( commas(recs), 9)       'records read from file: '        inFID
      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
tell:          do '0'arg(2);   call lineout outFID," "     ;   if term  then say ;     end
                               call lineout outFID,arg(1)  ;   if term  then say arg(1)
               do '0'arg(3);   call lineout outFID," "     ;   if term  then say ;     end
       return       /*show BEFORE blank lines (if any), message, show AFTER blank lines.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
tSort: tied=;                            r= 0    /*add true rank (tR) ───► the entries. */
               do j=#  by -1  for #;     r= r+1;   tR= r;   !tR.j= r;   jp= j+1;   jm= j-1
               if tied==''  then pR= r;  tied=   /*handle when language rank is untied. */
               if #.j==#.jp | #.j==#.jm  then do;    !.j= '[tied]';     tied= !.j;     end
               if #.j==#.jp              then do;    tR= pR;            !tR.j= pR;     end
                                         else pR= r
               end   /*j*/;      return
