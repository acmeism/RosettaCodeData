/*REXX program  encodes  several example text strings  using  the  ROT-13  algorithm.   */
$='foo'                         ; say "simple text=" $;  say 'rot-13 text=' rot13($);  say
$='bar'                         ; say "simple text=" $;  say 'rot-13 text=' rot13($);  say
$="Noyr jnf V, 'rer V fnj Ryon."; say "simple text=" $;  say 'rot-13 text=' rot13($);  say
$='abc?  ABC!'                  ; say "simple text=" $;  say 'rot-13 text=' rot13($);  say
$='abjurer NOWHERE'             ; say "simple text=" $;  say 'rot-13 text=' rot13($);  say
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
rot13: return  translate( arg(1), 'abcdefghijklmABCDEFGHIJKLMnopqrstuvwxyzNOPQRSTUVWXYZ',,
                                  "nopqrstuvwxyzNOPQRSTUVWXYZabcdefghijklmABCDEFGHIJKLM")
