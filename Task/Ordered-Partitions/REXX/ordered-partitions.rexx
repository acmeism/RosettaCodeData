/*REXX program displays ordered partitions: orderedPartitions(i,j,k,···)*/
call orderedPartitions 2,0,2           /*Note:    2,,2    will also work*/
call orderedPartitions 1,1,1
call orderedPartitions 1,2,0,1         /*Note:    1,2,1   will also work*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ORDEREDPARTITIONS subroutine────────*/
orderedPartitions: procedure; #=arg(); hdr=;  bot.=;  top.=;  low=;  high=
d=123456789                            /*handy-dandy literal for digits.*/
t=0                                    /*T: is the sum of all arguments.*/
      do i=1  for #;  t=t+('0'arg(i))  /*sum all the highest #s in parts*/
      end   /*i*/
                                       /* [↓]  process each of arguments*/
  do j=1  for #;   _=arg(j)            /*  _:  is the    Jth   argument.*/
  len.j=max(1,_)                       /*LEN:  length of args, 0=special*/
  bot.j=left(d,_);          if _==0 then bot.j=0 /*define the bottom num*/
  top.j=right(left(d,t),_); if _==0 then top.j=0 /*  "     "    top   " */
  @.j=left(d,t);            if _==0 then @.j=0   /*define VERIFY digits.*/
  hdr=hdr _                                      /*build display header.*/
  low=low || bot.j;         high=high || top.j   /*low and high of loop.*/
  end   /*j*/

okD=left(0||d,t+1)                     /*define legal digits to be used.*/
say center(' partitions for: ' hdr" ",50,'─');  say

    do g=low  to high                  /* [↑]   generate ordered parts. */
    if verify(g,okD)\==0  then iterate /*filter out the unwanted digits.*/
    p=1                                /*P:  is the position of a digit.*/
    $=                                 /*$:  will be the transformed #s.*/
       do k=1  for #                   /*verify the partitions numbers. */
                                       /*validate#: dups/ordered/repeats*/
       _=substr(g,p,len.k)             /*ordered part num. to be tested.*/
       if verify(_,@.k)\==0  then iterate g        /*is digit ¬ valid ? */
       !=                                          /* [↓]  validate num.*/
       if @.k\==0  then do j=1  for length(_);     z=substr(_,j,1)
                        if pos(z,$)\==0            then iterate g /*prev*/
                        !=!','z
                        if j==1  then iterate
                        if z<=substr(_,j-1,1)      then iterate g /*ord.*/
                        if pos(z,_,1+pos(z,_))\==0 then iterate g /*dup.*/
                        end   /*j*/
       p=p+len.k                                      /*point to next #.*/
       $=$ ' {'strip(translate(!,,0),,',')"}"         /*dress the # up. */
       end   /*k*/

    say $
    end      /*g*/
say
return
