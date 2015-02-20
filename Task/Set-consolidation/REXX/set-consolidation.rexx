/*REXX program demonstrates how to  consolidate  a sample bunch of sets.*/
sets.  =                               /*assign all    SETS.   to  null.*/
sets.1 = '{A,B}     {C,D}'
sets.2 = "{A,B}     {B,D}"
sets.3 = '{A,B}     {C,D}     {D,B}'
sets.4 = '{H,I,K}   {A,B}     {C,D}     {D,B}     {F,G,H}'
sets.5 = '{snow,ice,slush,frost,fog} {iceburgs,icecubes} {rain,fog,sleet}'

        do j=1  while sets.j\==''      /*traipse through the sample sets*/
        call SETcombo sets.j           /*have the other guy do the work.*/
        end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SETCOMBO subroutine─────────────────*/
SETcombo: procedure;   parse arg bunch;      n=words(bunch);     newBunch=
say ' the old sets=' space(bunch)

  do k=1  for n                        /* [↓]  change commas to a blank.*/
  @.k=translate(word(bunch,k),,'},{')  /*create a list of words (=a set)*/
  end   /*k*/                          /*··· and also remove the braces.*/

  do  until \changed;    changed=0     /*consolidate some sets  (maybe).*/
       do set=1  for n-1
           do item=1  for words(@.set);       x=word(@.set,item)
               do other=set+1  to n
               if isIn(x,@.other)  then do;   changed=1   /*has changed.*/
                                        @.set=@.set @.other;    @.other=
                                        iterate set
                                        end
               end   /*other*/
           end       /*item*/
       end           /*set*/
  end                /*until ¬changed*/

     do set=1  for n;   new=           /*remove duplicates in a set.    */
       do items=1  for words(@.set);   x=word(@.set, items)
       if x==','  then iterate;        if x==''  then leave
       new=new x                       /*start building the new set.    */
         do  until  \isIn(x, @.set)
         _=wordpos(x, @.set)
         @.set=subword(@.set,1,_-1) ',' subword(@.set,_+1) /*purify set.*/
         end    /*until ¬isIn*/
       end      /*items*/
     @.set=translate(strip(new), ',', " ")
     end        /*set*/

  do new=1  for n;            if @.new=='' then iterate
  newBunch=space(newbunch '{'@.new"}")
  end   /*new*/

say ' the new sets=' newBunch;   say
return
/*──────────────────────────────────ISIN subroutine─────────────────────*/
isIn: return wordpos(arg(1), arg(2))\==0  /*is (word) arg1 in set arg2? */
