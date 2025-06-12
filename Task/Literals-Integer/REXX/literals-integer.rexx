-- 19 May 2025
include Settings

say 'LITERALS INTEGER'
say version
say
say 'The standard precision (numeric digits) is 9'
say
say 'Assigments are as string...'
a = 6666666666666; say a
say 'until you do a calculation'
say a/1
say
say 'Decimal...'
l = 8
a = 0123; say left(a,l) '=' a/1
a = 123; say left(a,l) '=' a/1
a = 123.; say left(a,l) '=' a/1
a = 123.0; say left(a,l) '=' a/1
a = "123"; say left(a,l) '=' a/1
a = '123'; say left(a,l) '=' a/1
a = ' 123 '; say left(a,l) '=' a/1
a = +123; say left(a,l) '=' a/1
a = '+123'; say left(a,l) '=' a/1
a = ' + 123 '; say left(a,l) '=' a/1
a = .0123E4; say left(a,l) '=' a/1
a = 12.3E1; say left(a,l) '=' a/1
a = '12.3e1'; say left(a,l) '=' a/1
a = 1230E-1; say left(a,l) '=' a/1
a = 1230E-01; say left(a,l) '=' a/1
say
say 'Hexadecimal...'
say 'Blanks to separate words and bytes are allowed'
l = 14
say left("'5a'x",l) '=' '5a'x
say left("'5A'x",l) '=' '5A'x
say left("'5A'X",l) '=' '5A'X
say left("'50515253'X",l) '=' '50515253'X
say left("'5051 5253'X",l) '=' '5051 5253'X
say left("'50 51 52 53'X",l) '=' '50 51 52 53'X
say
say 'Binary...'
say 'Blanks to separate words, bytes and nibbles are allowed'
l = 42
say left("'1010000010100010101001001010011'B",l) '=' '1010000010100010101001001010011'B
say left("'01010000010100010101001001010011'B",l) '=' '01010000010100010101001001010011'B
say left("'0101000001010001 0101001001010011'B",l) '=' '0101000001010001 0101001001010011'B
say left("'01010000 01010001 01010010 01010011'B",l) '=' '01010000 01010001 01010010 01010011'B
say left("'0101 0000 0101 0001 0101 0010 0101 0011'B",l) '=' '0101 0000 0101 0001 0101 0010 0101 0011'B
exit

include Helper
include Abend
