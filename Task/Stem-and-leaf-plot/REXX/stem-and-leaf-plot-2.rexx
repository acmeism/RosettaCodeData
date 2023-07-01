/*REXX program displays a stem─and─leaf plot of any real numbers [can be:  neg, 0, pos].*/
parse arg @                                      /*obtain optional arguments from the CL*/
if @=''  then @='15 14 3 2 1 0 -1 -2 -3 -14 -15' /*Not specified?  Then use the default.*/
#.=;                  bot=.;    top=.;      z=.  /* [↑]  define all #. elements as null.*/
      do j=1  for words(@);     y=word(@, j)     /*◄─── process each number in the list.*/
      if \datatype(y,"N")  then do; say '***error*** item' j "isn't numeric:" y; exit; end
      n=format(y,,0)/1;  an=abs(n); s=sign(n)    /*normalize the numbers (not malformed)*/
      stem=left(an, length(an) -1)
      if stem==''  then if s>=0  then stem=0     /*handle case of one-digit positive #. */
                                 else stem='-0'  /*   "     "   "  "    "   negative "  */
                   else stem=s * stem            /*   "     "   " a  multi-digit number.*/
      parse var  n '' -1 leaf                    /*obtain the leaf (the last digit) of #*/
      if bot==.  then do; bot=stem; top=bot; end /*handle the first case for TOP and BOT*/
      bot=min(bot, stem);     top=max(top, stem) /*obtain the minimum and maximum so far*/
      if stem=='-0'  then z=0                    /*use  Z  as a flag to show negative 0.*/
      #.stem.leaf= #.stem.leaf  leaf             /*construct sorted stem-and-leaf entry.*/
      end   /*j*/

w=max(length(min), length(max) )  + 1            /*W:  used to right─justify the output.*/
!='-0'                                           /* [↓]  display the stem-and-leaf plot.*/
      do k=bot  to top;           $=             /*$:  is the output string, a plot line*/
      if k==z  then do                           /*handle a special case for negative 0.*/
                       do s=0  for 10; $=$ #.!.s /*build a line for the stem─&─leaf plot*/
                       end  /*s*/                /* [↑]  address special case of  -zero.*/
                    say right(!, w) '║' space($) /*display a line of stem─and─leaf plot.*/
                    end                          /* [↑]  handles special case of  -zero.*/
      $=                                         /*a new plot line  (of output).        */
                    do m=0  for 10;  $=$  #.k.m  /*build a line for the stem─&─leaf plot*/
                    end  /*m*/
      say right(k, w)    '║'    space($)         /*display a line of stem─and─leaf plot.*/
      end   /*k*/                                /*stick a fork in it,  we're all done. */
