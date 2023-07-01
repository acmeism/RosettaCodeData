/*REXX program finds a  value  in a  list of integers  using an iterative binary search.*/
@=  3   7  13  19  23  31  43  47  61  73  83  89 103 109 113 131 139 151 167 181,
  193 199 229 233 241 271 283 293 313 317 337 349 353 359 383 389 401 409 421 433,
  443 449 463 467 491 503 509 523 547 571 577 601 619 643 647 661 677 683 691 709,
  743 761 773 797 811 823 829 839 859 863 883 887 911 919 941 953 971 983 1013
                                                 /* [↑]  a list of some low weak primes.*/
parse arg ? .                                    /*get a  #  that's specified on the CL.*/
if ?==''  then do;    say;       say '***error***  no argument specified.';       say
                      exit                       /*stick a fork in it,  we're all done. */
               end
 low= 1
high= words(@)
 avg= (word(@, 1) + word(@, high)) / 2
 loc= binarySearch(low, high)

if loc==-1  then do;  say  ?  " wasn't found in the list."
                      exit                       /*stick a fork in it,  we're all done. */
                 end
            else say  ?  ' is in the list, its index is: '   loc
say
say  'arithmetic mean of the '   high   " values is: "       avg
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
binarySearch:  procedure expose @ ?;     parse arg low,high
               if high<low  then return -1       /*the item wasn't found in the @ list. */
               mid= (low + high) % 2             /*calculate the midpoint in the list.  */
               y= word(@, mid)                   /*obtain the midpoint value in the list*/
               if ?=y       then return  mid
               if y>?       then return  binarySearch(low,   mid-1)
                                 return  binarySearch(mid+1, high)
