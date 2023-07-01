   NB. solution
chars=: 9&u:@>
longestFirst=: \: #@chars
lengthAndString=: ([:":@,.#@chars),.' ',.chars

   NB. `Haruno-umi Hinemosu-Notari Notarikana'
   NB. Spring ocean ; Swaying gently ; All day long.

   lengthAndString longestFirst '春の海';'ひねもすのたり';'のたりかな'
7 ひねもすのたり
5 のたりかな
3 春の海
   lengthAndString longestFirst '1234567';'abcd';'123456789';'abcdef'
9 123456789
7 1234567
6 abcdef
4 abcd
