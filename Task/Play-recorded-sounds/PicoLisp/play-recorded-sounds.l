(call 'sox
   "-m"  "-v" "0.75" "a.wav"  "-v" "0.25" "b.wav"
   "-d"
   "trim" 4 6
   "repeat" 5 )
