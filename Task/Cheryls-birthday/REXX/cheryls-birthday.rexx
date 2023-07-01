/*REXX pgm finds Cheryl's birth date based on a person knowing the birth month, another */
/*──────────────────────── person knowing the birth day, given a list of possible dates.*/
$= 'May-15 May-16 May-19 June-17 June-18 July-14 July-16 August-14 August-15 August-17'
call delDays unique('day')
$= unique('day')
$= unique('month')
if words($)==1  then say "Cheryl's birthday is"  translate($, , '-')
                else say "error in the program's logic."
exit 0
/*──────────────────────────────────────────────────────────────────────────────────────*/
unique:  arg u 2, dups;  #= words($);   $$= $
            do    j=#  to 2  by -1
            if u=='D'     then parse value word($, j)  with  '-'   x
                          else parse value word($, j)  with   x   '-'
               do k=1  for j-1
               if u=='D'  then parse value word($, k)  with  '-'   y
                          else parse value word($, k)  with   y   '-'
               if x==y    then dups= dups k j
               end   /*k*/
            end      /*j*/
                                  do    d=#  for #  by -1
                                     do p=1  for words(dups)  until ?==d;  ?= word(dups,p)
                                     if ?==d  then  $$= delword($$, ?, 1)
                                     end   /*d*/
                                  end      /*d*/
         if words($$)==0  then return $
                          else return $$
/*──────────────────────────────────────────────────────────────────────────────────────*/
delDays: parse arg days;  #= words(days)
           do    j=#   for #   by -1;  parse value word(days, j) with x '-';  ##= words($)
              do k=##  for ##  by -1;  parse value word($,    k) with y '-'
              if x\==y  then iterate;  $= delword($, k, 1)
              end   /*k*/
           end      /*j*/
         return $
