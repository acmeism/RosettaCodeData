Blocks = [ :BO, :XK, :DQ, :CP, :NA, :GT, :RE, :TG, :QD, :FS, :JW, :HU, :VI, :AN, :OB, :ER, :FS, :LY, :PC, :ZM ]
Words = [ :A, :BARK, :BOOK, :TREAT, :COMMON, :SQUAD, :CONFUSE ]

for x in words
see '>>> can_make_word("' + upper(x) + '")' + nl
if checkword(x,blocks) see "True" + nl
else see "False" + nl
ok
next

func CheckWord Word,Blocks
cBlocks = BLocks
for x in word
Found = false
for y = 1 to len(cblocks)
if x = cblocks[y][1] or x = cblocks[y][2]
cblocks[y] = "--"
found = true
exit
ok
next
if found = false return false ok
next
return true
