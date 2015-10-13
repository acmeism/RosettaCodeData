/*REXX program encodes several example text strings with the ROT-13 algorithm.*/
@simple = 'simple text ='
@rot_13 = 'rot-13 text ='

$= 'foo'                          ;  say @simple $;  say @rot_13  rot13($);  say
$= 'bar'                          ;  say @simple $;  say @rot_13  rot13($);  say
$= "Noyr jnf V, 'rer V fnj Ryon." ;  say @simple $;  say @rot_13  rot13($);  say
$= 'abc?  ABC!'                   ;  say @simple $;  say @rot_13  rot13($);  say
$= 'abjurer NOWHERE'              ;  say @simple $;  say @rot_13  rot13($);  say

exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
rot13: return translate(arg(1), ,
                       'abcdefghijklmABCDEFGHIJKLMnopqrstuvwxyzNOPQRSTUVWXYZ', ,
                       'nopqrstuvwxyzNOPQRSTUVWXYZabcdefghijklmABCDEFGHIJKLM')
