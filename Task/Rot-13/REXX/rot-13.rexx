/*REXX program to encode several text strings with  ROT 13 algorithm.   */
aa = 'foo'
say 'simple text = 'aa
say ' rot13 text = 'rot13(aa)
say

bb = 'bar'
say 'simple text = 'bb
say ' rot13 text = 'rot13(bb)
say

cc = "Noyr jnf V, 'rer V fnj Ryon."
say 'simple text = 'cc
say ' rot13 text = 'rot13(cc)
say

dd = 'abc?  ABC!'
say 'simple text = 'dd
say ' rot13 text = 'rot13(dd)
say

ee = 'abjurer NOWHERE'
say 'simple text = 'ee
say ' rot13 text = 'rot13(ee)
exit                                   /*stick a fork in it, we're done.*/

/*──────────────────────────────────ROT13 subroutine────────────────────*/
rot13: return translate(arg(1),,
  'abcdefghijklmABCDEFGHIJKLMnopqrstuvwxyzNOPQRSTUVWXYZ',,
  'nopqrstuvwxyzNOPQRSTUVWXYZabcdefghijklmABCDEFGHIJKLM')
