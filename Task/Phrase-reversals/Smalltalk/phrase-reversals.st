|str|
str := 'rosetta code phrase reversal'.

Transcript showCR:(str reversed).
Transcript showCR:(((str splitBy:$ ) collect:#reversed) join:$ ).
Transcript showCR:(((str splitBy:$ ) reversed) join:$ ).
