targetfile := "ahk-file"
if FileExist(targetfile)
	FileMove, %targetfile%, %targetfile%.bak
else
	FileAppend,, %targetfile%
file := FileOpen(targetfile, "w")
if !IsObject(file)
{
	MsgBox Can't open "%FileName%" for writing.
	return
}
file.Write("This is a test string.`r`n")
file.Close()
