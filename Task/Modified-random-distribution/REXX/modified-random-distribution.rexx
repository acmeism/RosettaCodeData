/*REXX program generates a "<" shaped probability of number generation using a modifier.*/
parse arg randn bins seed .                      /*obtain optional argument from the CL.*/
if randN=='' | randN==","  then randN= 100000    /*Not specified?  Then use the default.*/
if  bins=='' |  bins==","  then  bins=     20    /* "      "         "   "   "     "    */
if datatype(seed, 'W')   then call random ,,seed /* "      "         "   "   "     "    */
call MRD
!.= 0
      do j=1  for randN;   bin= @.j*bins%1
      !.bin= !.bin + 1                           /*bump the applicable bin counter.     */
      end   /*j*/
mx= 0
      do k=1  for randN;   mx= max(mx, !.k)      /*find the maximum, used for histograph*/
      end   /*k*/

say '  bin'
say '────── '   center('(with '    commas(randN)    " samples",  80 - 10)

       do b=0  for bins;  say format(b/bins,2,2)   copies('■', 70*!.b%mx)" "   commas(!.b)
       end   /*b*/
exit 0
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas:   arg ?;  do jc=length(?)-3  to 1  by -3;  ?=insert(',', ?, jc);  end;    return ?
rand:     return random(0, 100000) / 100000
/*──────────────────────────────────────────────────────────────────────────────────────*/
modifier: parse arg y;   if y<.5  then return  2 * (.5 -  y)
                                  else return  2 * ( y - .5)
/*──────────────────────────────────────────────────────────────────────────────────────*/
MRD:      #=0;                      @.=          /*MRD:  Modified Random distribution.  */
            do until #==randN;      r= rand()    /*generate a random number; assign bkup*/
            if rand()>=modifier(r)  then iterate /*Doesn't meet requirement?  Then skip.*/
            #= # + 1;               @.#= r       /*bump counter; assign the MRD to array*/
            end   /*until*/
          return
