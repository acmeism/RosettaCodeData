/*REXX program demonstrates a 3x3 sandpile model by addition with toppling & avalanches.*/
@.= 0;   size= 3                                 /*assign 0 to all grid cells; grid size*/
call init   1,      1 2 0    2 1 1    0 1 3      /*   "   grains of sand──► sandpile 1. */
call init   2,      2 1 3    1 0 1    0 1 0      /*   "      "    "   "  "     "     2  */
call init   3,      3 3 3    3 3 3    3 3 3      /*   "      "    "   "  "     "     3  */
call init 's3_id',  2 1 2    1 0 1    2 1 2      /*   "      "    "   "  "     "    3_id*/
call show   1                                    /*display sandpile  1  to the terminal.*/
call show   2                                    /*   "        "     2   "  "      "    */
call  add   1, 2, 'sum1',           'adding sandpile  s1  and  s2  yields:'
call show 'sum1'
call  add   2, 1, 'sum2',           'adding sandpile  s2  and  s1  yields:'
call show 'sum2'
call  eq? 'sum1', 'sum2'                         /*is  sum1  the same as  sum2 ?        */
call show   3
call show 's3_id'
call  add   3,     's3_id', 'sum3', 'adding sandpile  s3  and  s3_id  yields:'
call show 'sum3'
call  add 's3_id', 's3_id', 'sum4', 'adding sandpile  s3_id  and  s3_id  yields:'
call show 'sum4'
call  eq? 'sum4',  's3_id'                       /*is  sum4  the same as  s3_id ?       */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
@get: procedure expose @.; parse arg grid,r,c    ;                      return @.grid.r.c
@set: procedure expose @.; parse arg grid,r,c,val;  @.grid.r.c= val;    return
tran: procedure; parse arg a;  if datatype(a,'W')  then a='s'a;         return a
/*──────────────────────────────────────────────────────────────────────────────────────*/
add:  parse arg x, y, t;    if t==''  then t= 'sum';  xx= tran(x);  yy= tran(y)
        do r=1  for size;   do c=1  for size;   @.t.r.c= @.xx.r.c  +  @.yy.r.c
                            end   /*c*/
        end   /*r*/;    say arg(4);             call norm t;            return
/*──────────────────────────────────────────────────────────────────────────────────────*/
eq?:  parse arg x, y;   xx= tran(x);      yy= tran(y);      ?= 1
        do r=1  for size;         do c=1  for size;         ?= ?  &  (@.xx.r.c==@.yy.r.c)
                                  end   /*c*/
        end   /*r*/
      if ?  then say  'comparison of '      xx       " and "       yy':  same.'
            else say  'comparison of '      xx       " and "       yy':  not the same.'
      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
init: parse arg x, $;   xx= tran(x);   #= 0;      pad= left('', 8);   ind= left('', 45)
        do r=1  for size;   do c=1  for size;     #= # + 1;           @.xx.r.c= word($, #)
                            end   /*c*/
        end   /*r*/;                              shows= 0;             return
/*──────────────────────────────────────────────────────────────────────────────────────*/
norm: procedure expose @. size; parse arg x;        xx= tran(x);            recurse= 0
        do r=1  for size;     do c=1  for size;     if @.xx.r.c<=size  then iterate
                              recurse= 1;              @.xx.r.c= @.xx.r.c - 4
                              call @set  xx, r-1, c  , @get(xx, r-1, c  )   +   1
                              call @set  xx, r+1, c  , @get(xx, r+1, c  )   +   1
                              call @set  xx, r  , c-1, @get(xx, r  , c-1)   +   1
                              call @set  xx, r  , c+1, @get(xx, r  , c+1)   +   1
                              end   /*c*/
        end   /*r*/;    if recurse  then call norm xx;                  return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: parse arg x;  xx= tran(x);  say ind center("sandpile" xx,25,'─')  /*show the title*/
        do r=1  for size;  $=;      do c=1  for size;   $= $  @.xx.r.c  /*build a row.  */
                                    end   /*c*/
        say ind pad $                                                   /*display a row.*/
        end   /*r*/;     shows= shows + 1;     if shows==1  then say;   return
