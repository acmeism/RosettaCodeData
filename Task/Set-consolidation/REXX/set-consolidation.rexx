/*REXX program  demonstrates  a method  of  consolidating  some sample  sets.           */
@.=;     @.1 = '{A,B}     {C,D}'
         @.2 = "{A,B}     {B,D}"
         @.3 = '{A,B}     {C,D}     {D,B}'
         @.4 = '{H,I,K}   {A,B}     {C,D}     {D,B}     {F,G,H}'
         @.5 = '{snow,ice,slush,frost,fog} {icebergs,icecubes} {rain,fog,sleet}'

               do j=1  while @.j\==''            /*traipse through each of sample sets. */
               call SETconsolidate @.j           /*have the function do the heavy work. */
               end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isIn:  return wordpos(arg(1), arg(2))\==0        /*is (word) argument 1 in the set arg2?*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
SETconsolidate: procedure;  parse arg old;       #=words(old);      new=
       say ' the old set=' space(old)

         do k=1  for #                           /* [↓]  change all commas to a blank.  */
         !.k=translate(word(old,k), , '},{')     /*create a list of words  (aka, a set).*/
         end   /*k*/                             /* [↑]  ··· and also remove the braces.*/

         do  until \changed;    changed=0        /*consolidate some sets  (well, maybe).*/
              do set=1  for #-1
                  do item=1  for words(!.set);       x=word(!.set, item)
                      do other=set+1  to #
                      if isIn(x, !.other)  then do;  changed=1            /*it's changed*/
                                                     !.set=!.set !.other;   !.other=
                                                     iterate set
                                                end
                      end   /*other*/
                  end       /*item */
              end           /*set  */
         end                /*until ¬changed*/

            do set=1  for #;   $=                                           /*elide dups*/
              do items=1  for words(!.set);   x=word(!.set, items)
              if x==','  then iterate;        if x==''  then leave
              $=$ x                                                         /*build new. */
                     do  until  \isIn(x, !.set)
                     _=wordpos(x, !.set)
                     !.set=subword(!.set, 1, _-1)  ','  subword(!.set, _+1) /*purify set*/
                     end   /*until ¬isIn ··· */
              end          /*items*/
            !.set=translate(strip($), ',', " ")
            end            /*set*/

         do i=1  for #; if !.i==''  then iterate /*ignore any  set  that is a null set. */
         new=space(new  '{'!.i"}")               /*prepend and append a set identifier. */
         end   /*i*/

       say ' the new set='  new;         say
       return
