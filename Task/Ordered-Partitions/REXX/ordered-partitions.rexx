/*REXX program displays  ordered partitions:    orderedPartitions(i, j, k, ···).        */
call orderedPartitions  2,0,2                    /*Note:      2,,2      will also work. */
call orderedPartitions  1,1,1
call orderedPartitions  1,2,0,1                  /*Note:      1,2,1     will also work. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
orderedPartitions: procedure;  #=arg();  hdr=;  bot.=;  top.=;  low=;  high=;  d=123456789
t=0                                              /*T:   is the sum of all the arguments.*/
      do i=1  for #;        t=t + arg(i)         /*sum all the highest numbers in parts.*/
      end   /*i*/                                /* [↑]  may have an omitted argument.  */
                                                 /* [↓]  process each of the arguments. */
  do j=1  for #;               _=arg(j)          /*  _:  is the    Jth   argument.      */
  len.j=max(1, _)                                /*LEN:  length of args, 0=special.     */
  bot.j=left(d, _);         if _==0 then bot.j=0 /*define the bottom number.            */
  top.j=right(left(d,t),_); if _==0 then top.j=0 /*  "     "    top     "               */
  @.j=left(d, t);           if _==0 then   @.j=0 /*define the digits used for  VERIFY.  */
  hdr=hdr _                                      /*build (by appending)  display header.*/
  low=low || bot.j;         high=high || top.j   /*the low and high numbers for DO below*/
  end   /*j*/

okD=left(0 || d, t+1)                            /*define the legal digits to be used.  */
say center(' partitions for: ' hdr" ", 60, '─')  /*display centered title for the output*/
say
    do g=low  to high                            /* [↑]  generate the ordered partitions*/
    if verify(g, okD)\==0  then iterate          /*filter out unwanted decimal digits.  */
    p=1                                          /*P:  is the position of a decimal dig.*/
    $=                                           /*$:  will be the transformed numbers. */
       do k=1  for #                             /*verify the partitions numbers.       */
                                                 /*validate number: dups/ordered/repeats*/
       _=substr(g,p,len.k)                       /*ordered partition number to be tested*/
       if verify(_, @.k)\==0  then iterate g     /*is the decimal digit not valid ?     */
       !=                                        /* [↓]  validate the decimal number.   */
       if @.k\==0  then do j=1  for length(_);            z=substr(_, j, 1)
                        if pos(z, $)\==0             then iterate g         /*previous. */
                        !=!','z
                        if j==1  then iterate                               /*is firstt?*/
                        if z<=substr(_, j-1, 1)      then iterate g         /*ordered.  */
                        if pos(z, _, 1+pos(z,_))\==0 then iterate g         /*duplicate.*/
                        end   /*j*/
       p=p + len.k                               /*point to the next decimal number.    */
       $=$ ' {'strip( translate(!, ,0), ,",")'}' /*dress number up by suppressing LZ ···*/
       end   /*k*/
    say '                  '    $                /*display numbers in ordered partition.*/
    end      /*g*/
say
return
