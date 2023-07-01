/*REXX program displays a stem and leaf plot of any non-negative numbers [can include 0]*/
parse arg @                                      /* [↓]  Not specified? Then use default*/
if @=''  then @=12 127 28 42 39 113 42 18 44 118 44 37 113 124 37 48 127 36 29 31 125 139,
   131 115 105 132 104 123 35 113 122 42 117 119 58 109 23 105 63 27 44 105 99 41 128 121,
   116 125  32  61 37 127 29 113 121 58 114 126 53 114 96 25 109 7 31 141 46 13 27 43 117,
   116  27 7 68 40 31 115 124 42 128 52 71 118 117 38 27 106 33 117 116 111 40 119 47 105,
   57 122 109 124 115 43 120 43 27 27 18 28 48 125 107 114 34 133 45 120 30 127 31 116 146
#.=;                            bot=.;    top=.  /* [↑]  define all #. elements as null.*/
     do j=1  for words(@);     y=word(@, j)      /*◄─── process each number in the list.*/
     if \datatype(y,"N")  then do; say '***error*** item' j "isn't numeric:" y;  exit; end
     if y<0               then do; say '***error*** item' j "is negative:"   y;  exit; end
     n=format(y, , 0) / 1                        /*normalize the numbers (not malformed)*/
     stem=word(left(n, length(n) -1)  0, 1)      /*obtain stem (1st digits) from number.*/
     parse var  n '' -1 leaf;   _=stem * sign(n) /*   "   leaf (last digit)   "    "    */
     if bot==.  then do;  bot=_;  top=_;  end    /*handle the first case for TOP and BOT*/
     bot=min(bot, _);           top=max(top, _)  /*obtain the minimum and maximum so far*/
     #.stem.leaf= #.stem.leaf   leaf             /*construct sorted stem-and-leaf entry.*/
     end   /*j*/

w=max(length(min), length(max) )    + 1          /*W:  used to right justify the output.*/
                                                 /* [↓]  display the stem-and-leaf plot.*/
     do k=bot  to top;          $=               /*$:  is the output string, a plot line*/
        do m=0  for 10;         $=$  #.k.m       /*build a line for the stem─&─leaf plot*/
        end  /*m*/
     say right(k, w)    '║'     space($)         /*display a line of stem─and─leaf plot.*/
     end   /*k*/                                 /*stick a fork in it,  we're all done. */
