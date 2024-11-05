/*REXX program computes and displays humble numbers,  also will display counts of sizes.*/
parse arg n m .                                  /*obtain optional arguments from the CL*/
if n=='' | n==","  then n= 50                    /*Not specified?  Then use the default.*/
if m=='' | m==","  then m= 60                    /* "      "         "   "   "     "    */
numeric digits 1 + max(20, m)                    /*be able to handle some big numbers.  */
$.= 0                                            /*a count array for  X  digit humble #s*/
call humble n;                    list=          /*call HUMBLE sub; initialize the list.*/
                  do j=1  for n;  list= list @.j /*append a  humble  number to the list.*/
                  end   /*j*/

if list\=''  then do;    say "A list of the first "    n    ' humble numbers are:'
                         say strip(list)         /*elide the leading blank in the list. */
                  end
say
call humble -m                                   /*invoke subroutine for counting nums. */
if $.1==0  then exit                             /*if no counts, then we're all finished*/
total= 0                                         /*initialize count of humble numbers.  */
$.1= $.1 + 1                                     /*adjust count for absent 1st humble #.*/
say '                    The digit counts of humble numbers:'
say '                 ═════════════════════════════════════════'
        do c=1  while $.c>0;  s= left('s', length($.c)>1)   /*count needs pluralization?*/
        say right( commas($.c), 30)         ' have '         right(c, 2)         " digit"s
        total= total + $.c                       /* ◄─────────────────────────────────┐ */
        end   /*k*/                              /*bump humble number count (so far)──┘ */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: procedure; arg _;  do i=length(_)-3 to 1 by -3; _=insert(',', _, i); end; return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
humble: procedure expose @. $.;   parse arg x;         if x==0  then return
        y= abs(x);   a= y;        noCount= x>0;        if x<0   then y= 999999999
        #2= 1;    #3= 1;    #5= 1;     #7= 1     /*define the initial humble constants. */
                  $.= 0;    @.= 0;    @.1= 1     /*initialize counts and humble numbers.*/
          do h=2  for y-1
          @.h= min(2*@.#2,3*@.#3,5*@.#5,7*@.#7)  /*pick the minimum of 4 humble numbers.*/
          m= @.h                                 /*M:    "     "     " "    "      "    */
          if 2*@.#2 == m   then #2 = #2 + 1      /*Is number already defined? Use next #*/
          if 3*@.#3 == m   then #3 = #3 + 1      /* "    "      "       "      "    "  "*/
          if 5*@.#5 == m   then #5 = #5 + 1      /* "    "      "       "      "    "  "*/
          if 7*@.#7 == m   then #7 = #7 + 1      /* "    "      "       "      "    "  "*/
          if noCount       then iterate          /*Not counting digits?   Then iterate. */
          L= length(m);    if L>a  then leave    /*Are we done with counting?  Then quit*/
          $.L= $.L + 1                           /*bump the digit count for this number.*/
          end   /*h*/                            /*the humble numbers are in the @ array*/
        return                                   /* "  count  results  "   "  "  $   "  */
