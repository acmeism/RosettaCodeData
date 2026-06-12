# syntax: GAWK -f AUDIOALARM.AWK
BEGIN {
    printf("enter seconds to wait: ")
    getline seconds
    if (seconds !~ /^[0-9]+$/ || seconds > 99999) {
      print("error: invalid")
      exit(1)
    }
    printf("enter filename to play: ")
    getline music_filename
    if (music_filename ~ /^ *$/) {
      print("error: invalid")
      exit(1)
    }
    if (toupper(music_filename) !~ /\.(MID|MOV|MP[34]|WAV|WMA)$/) {
      music_filename = music_filename ".MP3"
    }
    system(sprintf("TIMEOUT /T %d",seconds))
    system(sprintf("START \"C:\\PROGRAM FILES\\WINDOWS MEDIA PLAYER\\WMPLAYER.EXE\" \"%s\"",music_filename))
    exit(0)
}
