> (defvar *str* "∀Ꮺ✤Л◒")
*STR*
> (subseq *str* 1) ; remove first character
"Ꮺ✤Л◒"
> (subseq *str* 0 (1- (length *str*))) ; remove last character
"∀Ꮺ✤Л"
> (subseq *str* 1 (1- (length *str*))) ; remove first and last character
"Ꮺ✤Л"
