/*REXX program displays a stem-and-leaf plot of real numbers  [-, 0, +].*/
min=                                   /*This program handles negatives */
max=                                   /* ··· and decimal fractions.    */
parse arg data; if data='' then data=, /*Not specified? Then use default*/
     12 127 28 42 39 113 42 18 44 118 44 37 113 124 37 48 127 36 29 31 125,
     139 131 115 105 132 104 123 35 113 122 42 117 119 58 109 23 105 63 27,
     44 105 99 41 128 121 116 125 32 61 37 127 29 113 121 58 114 126 53 114,
     96 25 109 7 31 141 46 13 27 43 117 116 27 7 68 40 31 115 124 42 128 52,
     71 118 117 38 27 106 33 117 116 111 40 119 47 105 57 122 109 124 115,
     43 120 43 27 27 18 28 48 125 107 114 34 133 45 120 30 127 31 116 146
#.=
     do j=1  for words(data);  _=format(word(data,j),,0)/1   /*normalize*/
     stem=left(_, max(1, length(_)-1)) /*extract the stem from the num. */
     if length(_)==1  then stem=0      /*handle single-digit leaves.    */
     if min==''       then min=stem;   if max==''   then max=stem
     min=min(min, stem*sign(_));       max=max(max, stem*sign(_))
     leaf=right(_,1)                   /*pick off the leaf from the num.*/
     #.stem.leaf=#.stem.leaf  leaf     /*construct a sorted stem-&-leaf.*/
     end   /*j*/

w=max(length(min),length(max))         /*width: used to align the stems.*/

  do k=min  to max;  _=;         do m=0  for 10;   _=_ #.k.m;   end  /*m*/
  say right(k,w) '│' space(_)
  end   /*k*/
                                       /*stick a fork in it, we're done.*/
