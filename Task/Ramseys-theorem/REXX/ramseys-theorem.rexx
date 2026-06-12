/*REXX program finds & displays a 17 node graph such that any four nodes are neither ···*/
/*────────────────────────────────────────── totally connected nor totally unconnected. */
@.=0;             #=17                           /*initialize the node graph to zero.   */
      do d=0  for #;            @.d.d= 2         /*set the diagonal elements to 2 (two).*/
      end   /*d*/

      do k=1  by 0  while k<=8                   /*K  is doubled each time through loop.*/
                do i=0  for #;  j= (i+k) // #    /*set a  row,column  and  column,row.  */
                @.i.j= 1;       @.j.i= 1         /*set two array elements to unity (1). */
                end   /*i*/
      k= k + k                                   /*double the value of K for each loop. */
      end             /*k*/
                                                 /* [↓]  display a connection grid.     */
      do r=0  for #;  _=;       do c=0  for #    /*build rows;  build column by column. */
                                _= _  @.r.c      /*add  (append)  the column to the row.*/
                                end   /*c*/

      say left('', 9)     translate(_, "─", 2)   /*display  (indented)  constructed row.*/
      end   /*r*/
!.= 0                                            /*verify the sub─graphs connections.   */
ok= 1                                            /*Ramsey's connections;   OK  (so far).*/
      do   v=0  for #                            /*check the sub─graphs # of connections*/
        do h=0  for #                            /*check column connections to the rows.*/
        if @.v.h==1  then !._v.v= !._v.v + 1     /*if connected,  then bump the counter.*/
        end   /*h*/                              /* [↑]  Note:  we're counting each ··· */
      ok= ok  &  !._v.v==# % 2                   /*      connection twice,  so      ··· */
      end     /*v*/                              /*      divide the total by two.       */
                                                 /* [↓]  check col. with row connections*/
      do   h=0  for #                            /*check the sub─graphs # of connections*/
        do v=0  for #                            /*check the row connection to a column.*/
        if @.h.v==1  then !._h.h= !._h.h + 1     /*if connected,  then bump the counter.*/
        end   /*v*/                              /* [↑]  Note:  we're counting each ··· */
      ok= ok  &  !._h.h==# % 2                   /*      connection twice,  so      ··· */
      end     /*h*/                              /*      divide the total by two.       */
say                                              /*stick a fork in it,  we're all done. */
say  space("Ramsey's condition is"word("'nt", 1+ok) 'satisfied.')     /*show yea─or─nay.*/
