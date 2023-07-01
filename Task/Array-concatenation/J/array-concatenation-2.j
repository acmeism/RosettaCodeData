   ]ab=: 3 3 $ 'aaabbbccc'
aaa
bbb
ccc
   ]wx=: 3 3 $ 'wxyz'
wxy
zwx
yzw
   ab , wx
aaa
bbb
ccc
wxy
zwx
yzw
   ab ,. wx
aaawxy
bbbzwx
cccyzw
   ab ,: wx
aaa
bbb
ccc

wxy
zwx
yzw
   $ ab , wx    NB. applies to first (highest) axis
6 3
   $ ab ,. wx   NB. applies to last (atomic) axis
3 6
   $ ab ,: wx   NB. applies to new (higher) axis
2 3 3
