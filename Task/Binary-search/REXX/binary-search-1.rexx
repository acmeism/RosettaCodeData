/*REXX program finds a value in a list using a recursive binary search. */
@=' 11  17  29  37  41  59  67  71  79  97 101 107 127 137 149',
  '163 179 191 197 223 227 239 251 269 277 281 307 311 331 347',
  '367 379 397 419 431 439 457 461 479 487 499 521 541 557 569',
  '587 599 613 617 631 641 659 673 701 719 727 739 751 757 769',
  '787 809 821 827 853 857 877 881 907 929 937 967 991 1009'
                                       /*(above)  list of strong primes.*/

parse arg ? .                          /*get a number the user specified*/
if ?=='' then do
              say;       say '*** error! *** no arg specified.';       say
              exit 13
              end
 low = 1
high = words(@)
avg=(word(@,1)+word(@,high))/2
 loc = binarySearch(low,high)

if loc==-1 then do
                say ? "wasn't found in the list."
                exit                   /*stick a fork in it, we're done.*/
                end
           else say ? 'is in the list, its index is:' loc
say
say 'arithmetic mean of the' high "values=" avg
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────BINARYSEARCH subroutine──────────*/
binarySearch:  procedure expose @ ?;     parse arg low,high
if high<low  then return -1
mid=(low+high)%2
y=word(@,mid)
if ?=y       then return mid
if y>?       then return binarySearch(low,mid-1)
                  return binarySearch(mid+1,high)
