/*REXX program displays a stem─and─leaf plot of any real numbers  [-, 0, +].  */
parse arg data                         /* [↓]  Not specified? Then use default*/
if data=''  then data=12 127 28 42 39 113 42 18 44 118 44 37 113 124 37 48 127 36 29 31,
  125 139 131 115 105 132 104 123 35 113 122 42 117 119 58 109 23 105 63 27 44 105 99 41,
  128 121 116 125 32 61 37 127 29 113 121 58 114 126 53 114 96 25 109 7 31 141 46 13 27 43,
  117 116 27 7 68 40 31 115 124 42 128 52 71 118 117 38 27 106 33 117 116 111 40 119 47 105,
  57 122 109 124 115 43 120 43 27 27 18 28 48 125 107 114 34 133 45 120 30 127 31 116 146
parse var data bot . 1 top . '' #.     /*define MIN & MAX as the first number.*/
                                       /* [↑]  define all #. elements as null.*/
     do j=1  for words(data);  _=format(word(data,j),,0)/1   /*normalize the #*/
     stem=left(_, max(1, length(_)-1)) /*extract the stem (1st dig) from the #*/
     if length(_)==1  then stem=0      /*special case:  single─digit leaves.  */
     bot=min(bot, stem*sign(_));   top=max(top, stem*sign(_))   /*find MIN,MAX*/
     parse var _ '' -1 leaf            /*obtain the leaf (last dig) from the #*/
     #.stem.leaf=#.stem.leaf  leaf     /*construct sorted stem-and-leaf entry.*/
     end   /*j*/

w=max(length(min), length(max)) +1     /*W:  used to right─justify the output.*/

  do k=bot  to top;            $=;     do m=0  for 10;   $=$ #.k.m;   end  /*m*/
  say right(k,w)   '║'   space($)
  end   /*k*/
                                       /*stick a fork in it,  we're all done. */
