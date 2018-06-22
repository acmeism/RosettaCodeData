//*REXX program displays the  ordered partitions  as:   orderedPartitions(i, j, k, ···). */
call orderedPartitions  2,0,2                    /*Note:      2,,2      will also work. */
call orderedPartitions  1,1,1
call orderedPartitions  1,2,0,1                  /*Note:      1,2,,1    will also work. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
orderedPartitions: procedure;  #=arg();   bot.=;   top.=;   low=;    high=;    d=123456789
t=0                                              /*T:   is the sum of all the arguments.*/
          do i=1  for #;       t=t + arg(i)      /*sum all the highest numbers in parts.*/
          end   /*i*/                            /* [↑]  may have an omitted argument.  */
hdr= ' partitions for: '                         /*define the start of the header text. */
  do j=1  for #;               _= arg(j)         /*  _:  is the    Jth   argument.      */
  len.j=max(1, _)                                /*LEN:  length of args.  «0 is special»*/
  bot.j=left(d, _);         if _==0 then bot.j=0 /*define the  bottom  number for range.*/
  top.j=right(left(d,t),_); if _==0 then top.j=0 /*  "     "     top      "    "    "   */
  @.j=left(d, t);           if _==0 then   @.j=0 /*define the digits used for  VERIFY.  */
  hdr=hdr _                                      /*build (by appending)  display header.*/
  low=low || bot.j;         high=high || top.j   /*the low and high numbers for DO below*/
  end   /*j*/
                                                 /* [↓]  same as:   okD=left('0'd, t+1) */
              /*define the legal digits to be used.  */
okD=left(0 || d,  t + 1)                         /*define the legal digits to be used.  */
say;   hdr=center(hdr" ",  60, '═');     say hdr /*display centered title for the output*/
say                                              /*show a blank line  (as a separator). */
    do g=low  to high                            /* [↑]  generate the ordered partitions*/
    if verify(g, okD) \==0  then iterate         /*filter out unwanted partitions (digs)*/
    p=1                                          /*P:  is the position of a decimal dig.*/
    $=                                           /*$:  will be the transformed numbers. */
       do k=1  for #;   _=substr(g, p, len.k)    /*verify the partitions numbers.       */
       if verify(_, @.k) \==0  then iterate g    /*is the decimal digit not valid ?     */
       !=                                        /* [↓]  validate the decimal number.   */
       if @.k\==0  then do j=1  for length(_);     z=substr(_, j, 1)        /*get a dig.*/
                        if pos(z, $)\==0               then iterate g       /*previous ?*/
                        !=!','z                                             /*add comma.*/
                        if j==1                        then iterate         /*is firstt?*/
                        if z<=substr(_, j-1, 1)        then iterate g       /*ordered  ?*/
                        if pos(z, _, 1 +pos(z, _))\==0 then iterate g       /*duplicate?*/
                        end   /*j*/
       p=p + len.k                               /*point to the next decimal digit (num)*/
       $=$ '  {'strip(translate(!, ,0), ,",")'}' /*dress number up by suppessing LZ ··· */
       end   /*k*/
    say center($, length(hdr) )                  /*display numbers in ordered partition.*/
    end      /*g*/
return
