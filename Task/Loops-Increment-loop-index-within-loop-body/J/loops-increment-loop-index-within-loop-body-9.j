   9!:37 ] 0 2048 0 222  NB. output control permit lines of 2^11 columns

   (>:@:i. ,: tacit_loop) 42
 1  2   3   4   5    6    7    8     9    10    11    12     13     14     15      16      17      18       19       20       21       22        23        24        25         26         27         28          29          30          31          32           33           34           35            36            37            38             39             40             41             42
43 89 179 359 719 1439 2879 5779 11579 23159 46327 92657 185323 370661 741337 1482707 2965421 5930887 11861791 23723597 47447201 94894427 189788857 379577741 759155483 1518310967 3036621941 6073243889 12146487779 24292975649 48585951311 97171902629 194343805267 388687610539 777375221081 1554750442183 3109500884389 6219001768781 12438003537571 24876007075181 49752014150467 99504028301131


   NB. fix the definition.  Here's the code.
   tacit_loop f.
[: }: (_1&(>:@:{`[`]})@:(, (1&p: # _1 2&p.)@:{:)@:]^:(0 ~: (>: #))^:_ x:)
