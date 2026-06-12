Inputbox, seconds, Seconds, Enter a number of seconds:
FileSelectFile, File, 3, %A_ScriptDir%, File to be played, MP3 Files (*.mp3)
Sleep Seconds*1000
RunWait % file
