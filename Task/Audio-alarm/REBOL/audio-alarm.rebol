Rebol [
  title: "Rosetta code: Audio_alarm"
  file: %AudioAlarm.r3
  url: https://rosettacode.org/wiki/Audio_alarm
  needs: 3.14.1
  note: [
    https://github.com/Oldes/Rebol3/releases
    https://github.com/Oldes/Rebol-MiniAudio
  ]
]

;; Initialize audio extension...
try/with [
  audio: import miniaudio
  audio/init-playback 1 ;; Use the first available audio device
][
  print "Failed to import audio module!"
  exit
]

;; Ask for the number of seconds to wait...
until [
  number? delay: transcode/one/error ask "Enter number of seconds delay: "
]

;; Ask for the filename of the alarm sound...
until [
  all [
    file: to-rebol-file ask "MP3 to play as alarm: "
    any [
      exists? file               ;; without extension
      exists? append file %.mp3  ;; with mp3 extension
    ]
  ]
]

;; Wait for the specified number of seconds...
print ["Waiting" delay "seconds"]
wait delay

;; Play the alarm sound...
audio/play file
