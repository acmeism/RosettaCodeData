/* REXX program finds a value in a list of integers                    */
/*  using an iterative binary search.                                  */
  list=3 7 13 19 23 31 43 47 61 73 83 89 103 109 113 131 139 151 167 181 193 199,
  229 233 241 271 283 293 313 317 337 349 353 359 383 389 401 409 421 433 443,
  449 463 467 491 503 509 523 547 571 577 601 619 643 647 661 677 683 691 709,
  743 761 773 797 811 823 829 839 859 863 883 887 911 919 941 953 971 983 1013
/* list: a list of some low weak primes.                               */
Parse Arg needle                      /* get a number to be looked for */
If needle=="" Then
  Call exit "***error***  no argument specified."
low=1
high=words(list)
Do While low<=high
  mid=(low+high)%2
  y=word(list,mid)
  Select
    When y=needle Then
      Call exit needle "is in the list, its index is:" mid'.'
    When y>needle Then         /* too high                             */
      high=mid-1               /* set upper nound                      */
    Otherwise                  /* too low                              */
      low=mid+1                /* set lower limit                      */
    End
  End
Call exit needle "wasn't found in the list."

exit: Say arg(1)
