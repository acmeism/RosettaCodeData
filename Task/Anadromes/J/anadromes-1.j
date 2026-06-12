words=: cutLF fread 'words.txt'
canon=: {.@/:~@(,:|.) each words
akeys=: (~. #~ 2 = #/.~) canon
tkeys=: (#~ 6 < #@>) akeys
order=: /: canon
pairs=: _2]\ (order{canon e. tkeys) # order { words
