/*REXX program  using  Knuth's  algorithm  S  (a random sampling   N   of   M   items). */
parse arg trials size .                          /*obtain optional arguments from the CL*/
if trials=='' | trials==","  then trials= 100000 /*Not specified?  Then use the default.*/
if   size=='' |   size==","  then   size=      3 /* "      "         "   "   "     "    */
#.= 0                                            /*initialize frequency counter array.  */
      do trials                                  /*OK,  now let's light this candle.    */
      call s_of_n_creator    size                /*create an initial list of  N  items. */

          do gen=0  for 10;  call s_of_n gen     /*call s_of_n with a single decimal dig*/
          end   /*gen*/
                                                 /* [↓]  examine what  SofN  generated. */
          do count=1  for size;     _= !.count   /*get a dec. digit from the  Nth item. */
          #._= #._ + 1                           /*bump counter for the decimal digit.  */
          end   /*count*/
      end       /*trials*/
                                                         @= ' trials, and with a size of '
hdr= "  Using Knuth's algorithm  S  for "  commas(trials)  @ || commas(size)":  "
say hdr;         say copies("═", length(hdr) )   /*display the header and its separator.*/

        do dig=0  to 9                           /* [↓]  display the frequency of a dig.*/
        say right("frequency of the", 37)       dig       'digit is: '      commas(#.dig)
        end   /*dig*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg _;  do jc=length(_)-3  to 1  by -3; _=insert(',', _, jc); end;  return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
s_of_n: parse arg item;         items= items + 1 /*get  "item",  bump the items counter.*/
        if random(1, items)>size  then return    /*probability isn't good,  so skip it. */
        _= random(1, size);       !._= item      /*now, figure out which previous ···   */
        return                                   /*      ··· item to replace with  ITEM.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
s_of_n_creator: parse arg item 1 items           /*generate    ITEM    number of items. */
                            do k=1  for item     /*traipse through the first  N  items. */
                            !.k= random(0, 9)    /*set the  Kth  item with random digit.*/
                            end   /*k*/
                return                           /*the piddly stuff is done  (for now). */
