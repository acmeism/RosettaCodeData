define(`concat',`$1$2')dnl
define(`A',`any text value')dnl
concat(`A',` concatenated with string literal')
define(`B',`concat(`A',` and string literal')')dnl
B
