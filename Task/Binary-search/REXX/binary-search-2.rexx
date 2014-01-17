/*REXX program finds a value in a list using an iterative binary search.*/
@=  3   7  13  19  23  31  43  47  61  73  83  89 103 109 113 131 139 151 167 181,
  193 199 229 233 241 271 283 293 313 317 337 349 353 359 383 389 401 409 421 433,
  443 449 463 467 491 503 509 523 547 571 577 601 619 643 647 661 677 683 691 709,
  743 761 773 797 811 823 829 839 859 863 883 887 911 919 941 953 971 983 1013
                                       /* [↑]     a list of weak primes.*/
parse arg ? .                          /*get a number the user specified*/
if ?==''  then do
               say;      say '*** error! *** no arg specified.';       say
               exit 13
               end
 low = 1
high = words(@)
say  'arithmetic mean of the'  high  "values="  (word(@,1)+word(@,high))/2
say
               do  while  low<=high;   mid=(low+high)%2;     y=word(@,mid)
               if ?=y  then do
                            say ?  'is in the list, its index is:'  mid
                            exit       /*stick a fork in it, we're done.*/
                            end

               if y>?  then high=mid-1
                       else  low=mid+1
               end   /*while*/

say  ?  "wasn't found in the list."
                                       /*stick a fork in it, we're done.*/
