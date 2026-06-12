data := ["http://example.com/download.tar.gz"
		,"CharacterModel.3DS"
		,".desktop"
		,"document"
		,"document.txt_backup"
		,"/etc/pam.d/login"]

for i, file in data{
	RegExMatch(file, "`am)\.\K[a-zA-Z0-9]+$", ext)
	result .= file " --> " ext "`n"
}
MsgBox % result
