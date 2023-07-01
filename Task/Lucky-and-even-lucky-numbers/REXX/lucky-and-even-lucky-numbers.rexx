/*REXX program displays  lucky  or  evenLucky  integers   (numbers  or  a number range).*/
parse arg bot top func _ .                       /*obtain required & optional arguments.*/
if func==''  then func= 'lucky'                  /*Not specified?  Then use the default.*/
s= left('s', bot\==top  &  top\==",")            /*plural results (or maybe not plural).*/
say func  'number's":"   bot  top   '───►'   $lucky(bot, top, func, _)
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
$lucky: arg x,y,f,?;   if y=='' | y==","  then y= x      /*obtain some arguments; set Y.*/
        #= 0;          $=;                    ny= y<0    /*set variable NOY: value range*/
        if f==''  then f= 'LUCKY';   lucky= (f=="LUCKY") /*assume  LUCKY  if omitted.   */
        if f\=='LUCKY' & f\=='EVENLUCKY'  then return  'function not valid: '     f
        if arg()>3  &  ?\=''      then return  "too many arguments entered: "     ?
        if x=''                   then return  "1st argument is missing."
        if x<1                    then return  "1st argument isn't a positive integer: " x
        if \datatype(x,'W')       then return  "1st argument isn't an integer: "  x
        if \datatype(y,'W')       then return  "2nd argument isn't an integer: "  y
        if x>ay                   then return  "2nd argument is less than 1st arg."
        ay=abs(y); yL=ay; if y>0  then yL= y*10  + y + y /*adjust the upper  Y  limit.  */
                                                         /* [↓]  build LUCKY | EVENLUCKY*/
            do j=1  until j>=yL                          /*construct list pos. integers.*/
            if j//2==(\lucky)  then iterate              /*EVENLUCKY? Use only even ints*/

            if lucky  then if (j+1)//6==0  then iterate  /*prune       if  mod 6 ≡ zero.*/
                                           else nop      /*balance the   IF-THEN  logic.*/
                      else if  j   //8==0  then iterate  /*prune next  if  mod 8 ≡ zero.*/
            #= # + 1                                     /*bump the counter of numbers. */
            $= $ j                                       /*append integer to the $ list.*/
            end   /*j*/
        q=0
            do p=3  until  q=='';       q= word($, p)    /*start to prune  integer list.*/
            if q>#  then leave                           /*if integer is too large, stop*/
                                do j=#%q*q  by -q  to q  /*elide every  Qth  integer.   */
                                $= delword($, j, 1)      /*delete a particular number.  */
                                #= # -1                  /*decrease the integer count.  */
                                end   /*j*/              /*delete from the right side.  */
            end   /*p*/
        @.=
                  do k=1;  parse var $ q $;       if q==''  then leave;       @.k= q
                  end   /*k*/
        @.0=k-1
                  do m=1  for #                          /*restrict the found integers. */
                  if (\ny  &  (m<x  |  m>ay))  |  (ny  &  (@.m<x | @.m>ay))  then @.m=
                  end   /*m*/                            /* [↑]  a list of #s or a range*/
        _=
                  do b=1  for @.0;     _= _ @.b          /*construct a list of integers.*/
                  end   /*b*/
        return space(_)                                  /*remove superfluous blanks.   */
