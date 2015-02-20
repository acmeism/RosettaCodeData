/*REXX program encodes several text strings with the  ROT-13  algorithm.*/
aa = 'foo'
                                        say 'simple text = 'aa
                                        say 'rot-13 text = 'rot13(aa)
                                        say
bb = 'bar'
                                        say 'simple text = 'bb
                                        say 'rot-13 text = 'rot13(bb)
                                        say
cc = "Noyr jnf V, 'rer V fnj Ryon."
                                        say 'simple text = 'cc
                                        say 'rot-13 text = 'rot13(cc)
                                        say
dd = 'abc?  ABC!'
                                        say 'simple text = 'dd
                                        say 'rot-13 text = 'rot13(dd)
                                        say
ee = 'abjurer NOWHERE'
                                        say 'simple text = 'ee
                                        say 'rot-13 text = 'rot13(ee)
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ROT13 subroutine────────────────────*/
rot13: return translate(arg(1), ,
              'abcdefghijklmABCDEFGHIJKLMnopqrstuvwxyzNOPQRSTUVWXYZ', ,
              'nopqrstuvwxyzNOPQRSTUVWXYZabcdefghijklmABCDEFGHIJKLM')
