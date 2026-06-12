# Project : AudioAlarm

load "stdlib.ring"
see "Delay in seconds: "
give sec
see "MP3 to play as alarm: "
give mp3
f = mp3 + ".mp3"
sleep(sec)
system("C:\Ring\wmplayer.exe C:\Ring\calmosoft\" + f)
