/*REXX program read two files and produces a ranked list of RC languages*/
sep='█';   L.=0;   #.=0;   u.=0;   catHeap=  /*assign variable defaults.*/
parse arg cutoff CinFID LinFID outFID .      /*obtain specified options.*/
if cutoff==',' | cutoff=='' then cutoff=0    /*assume no cutoff default.*/

if CinFID=='' then CinFID='RC_POP.CAT' /*not specified?    Use default. */
if LinFID=='' then LinFID='RC_POP.LAN' /*not specified?    Use default. */
if outFID=='' then outFID='RC_POP.OUT' /*not specified?    Use default. */

call tell center('timestamp: ' date() time('Civil'),79,'═'), 1, 1
#langs=reader('lang')                            /*assign to   L.ααα    */
#cats =reader('cat')                             /*append to the catHeap*/
#=0                                              /*number of categories.*/
     do j=1 until catHeap==''                    /*process heap of cats.*/
     parse var catHeap cat.j (sep) catHeap       /*pick off a category. */
     parse var cat.j cat.j '<' '(' mems .        /*untangle the string. */
     cat.j=space(cat.j);  _=cat.j; upper _       /*remove excess blanks.*/
     if _=='' | \L._         then iterate        /*blank or ¬ a language*/
     if \datatype(mems,'W')  then iterate        /*"members"  ¬ numeric.*/
                                                 /*handle duplicates.   */
     if u._\==0 then do  /*(next) Possible echo the duplicate to screen.*/
                     /*─── say duplicate found: ' cat.j ───*/
                             do f=1  for # until _==@u.f;  end /*f*/
say  cat.j 'is a dup, old=' #.f  'add mems='mems
                     #.f=#.f+mems;  iterate j
                     end
     u._=u._+1
     #=#+1; #.#=mems; @.#=cat.j; @u.#=_; #.#=mems /*bump counter, assign.*/
     end   /*j*/

call tell # '(total) number of languages detected, ',
          # 'language's(#) "found with number of entries ≥" cutoff, 1, 1
call esort #                           /*sort the languages along with #*/
rank=0;  tied=                         /* [↓]  show by ascending rank.  */

  do j=#  by -1  for #  while  #.j>=cutoff;                    rank=rank+1
  if tied==''  then pRank=rank
  tRank=rank;  jp=j+1;  jm=j-1;    tied=
  if #.j==#.jp  |  #.j==#.jm  then tied='(tied)'
  if #.j==#.jp                then tRank=pRank
                              else pRank= Rank

  call   tell   right('rank:'right(tRank,4),20)  left(tied,6),
                right('('#.j left("entr"s(#.j,'ies',"y")')',9),20)  @.j
  end   /*j*/
                 call tell '                     ☼  end-of-list.  ☼', 1, 2
if cutoff>0 then call tell '  Listing stopped due to a cutoff of' cutoff"."
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────ESORT subroutine───────────────────────*/
esort: procedure expose #. @.;      arg N;        h=N
         do  while h>1;       h=h%2
           do i=1  for N-h;   j=i;   k=h+i
               do  while #.k<#.j       /*use hard swaps: @. have blanks.*/
               @=@.j;   #=#.j;     @.j=@.k;    #.j=#.k;    @.k=@;    #.k=#
               if h>=j  then leave;            j=j-h;      k=k-h
               end    /*while #.k<#.j*/
           end        /*i*/
         end          /*while h>1*/
return
/*───────────────────────────────READER subroutine──────────────────────*/
reader: arg which 2;  n=0;  ig_ast=1   /*ARG uppers WHICH, gets 1st char*/
if which=='L'  then inFID=Linfid       /*use this fileID for languages. */
if which=='C'  then inFID=Cinfid       /* "    "     "    "  categories.*/
oldMc='╬£C++';      newMc=  "µC++"     /*Unicode ╬£C++ ──> ASCII-8: µC++*/
oldUc='UC++'                           /*old      UC++ ──> ASCII-8: µC++*/
oldMK='╨£╨Ü-';      newMK=  "MK-"      /*Unicode ╨£╨Ü- ──> ASCII-8: MK- */
oldDV='D├⌐j├á';     newDV=  'Déjá'     /*Unicode ├⌐j├á ──> ASCII-8: Déjá*/
oldCA='Cach├⌐';     newCA=  'Caché'    /*Unicode ach├⌐ ──> ASCII-8: aché*/

  do  while lines(inFID)\==0           /*read a file,  1 line at a time.*/
  $=translate(linein(inFID),,'9'x)     /*handle any stray tab characters*/
  $$=space($); if $$==''  then iterate /*ignore all blank lines.        */
  if pos(oldMc,$$)\==0 then $$=changestr(oldMc,$$,newMc) /*convert micro*/
  if pos(oldUc,$$)\==0 then $$=changestr(oldUc,$$,newMc) /*convert µC++ */
  if pos(oldMK,$$)\==0 then $$=changestr(oldMK,$$,newMK) /*convert MK-  */
  if pos(oldDV,$$)\==0 then $$=changestr(oldDV,$$,newDV) /*convert Déjá */
  if pos(oldCA,$$)\==0 then $$=changestr(oldCA,$$,newCA) /*convert Caché*/
  $u=$;        upper $u                /*get an uppercase version.      */
  if ig_ast then  do; ig_ast=pos(' * ',$u)==0; if ig_ast then iterate; end
  if pos('RETRIEVED FROM',$u)\==0  then leave    /*a pseudo End-Of-Data.*/
  n=n+1                                /*bump counter: legimate records.*/
  if which=='L' then do
                     if left($$,1)\=='*'  then iterate       /*legimate?*/
                     parse upper var $$ '*' $$ '<';          $$=space($$)
                     L.$$=1            /*languages are stored uppercase.*/
                     iterate           /*iterates the DO WHILE LINES(...*/
                     end               /*(above) pick off language name.*/

  if left($$,1)=='*'  then $$=sep || space(substr($$,2))
  catHeap=catHeap $$                   /*append to the (CATegory) heap. */
  end   /*while lines...*/

call tell   right(n,9)   'records read from file: '   inFID
return n
/*───────────────────────────────S subroutine───────────────────────────*/
s: if arg(1)==1 then return arg(3);  return word(arg(2) 's',1)  /*plural*/
/*───────────────────────────────TELL subroutine────────────────────────*/
tell:   do '0'arg(2);   call lineout outFID,' '     ;   say         ;  end
                        call lineout outFID,arg(1)  ;   say arg(1)
        do '0'arg(3);   call lineout outFID,' '     ;   say         ;  end
return  /*show before blanks lines (if any), MSG, show after blank lines*/
