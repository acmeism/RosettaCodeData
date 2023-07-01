Anagrams	New ii,file,longest,most,sorted,word
	Set file="unixdict.txt"
	Open file:"r" Use file
	For  Quit:$ZEOF  DO
	. New char,sort
	. Read word Quit:word=""
	. For ii=1:1:$Length(word) Do
	. . Set char=$ASCII(word,ii)
	. . If char>64,char<91 Set char=char+32
	. . Set sort(char)=$Get(sort(char))+1
	. . Quit
	. Set (sorted,char)="" For  Set char=$Order(sort(char)) Quit:char=""  Do
	. . For ii=1:1:sort(char) Set sorted=sorted_$Char(char)
	. . Quit
	. Set table(sorted,word)=1
	. Quit
	Close file
	Set sorted="" For  Set sorted=$Order(table(sorted)) Quit:sorted=""  Do
	. Set ii=0,word="" For  Set word=$Order(table(sorted,word)) Quit:word=""  Set ii=ii+1
	. Quit:ii<2
	. Set most(ii,sorted)=1
	. Quit
	Write !,"The anagrams with the most variations:"
	Set ii=$Order(most(""),-1)
	Set sorted="" For  Set sorted=$Order(most(ii,sorted)) Quit:sorted=""  Do
	. Write ! Set word="" For  Set word=$Order(table(sorted,word)) Quit:word=""  Write "  ",word
	. Quit
	Write !,"The longest anagrams:"
	Set ii=$Order(longest(""),-1)
	Set sorted="" For  Set sorted=$Order(longest(ii,sorted)) Quit:sorted=""  Do
	. Write ! Set word="" For  Set word=$Order(table(sorted,word)) Quit:word=""  Write "  ",word
	. Quit
	Quit

Do Anagrams
