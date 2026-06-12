Rebol [
    title: "Rosetta code: Audio overlap loop"
    file:  %Audio_overlap_loop.r3
    url:   https://rosettacode.org/wiki/Audio_overlap_loop
]

;; Import the MiniAudio extension for audio playback functionality
;; See: https://github.com/Oldes/Rebol-MiniAudio
audio: import miniaudio

;; Path to the audio file to be played
file: %drumloop.wav
;; How many overlapping instances of the sound to play
number-of-sounds: 8
;; Seconds between each sound's start time (creates a staggered/canon effect)
delay-between-sounds: 0.01

;; Download the sample audio file if it doesn't already exist locally
unless exists? file [
    write file
     read https://github.com/Oldes/Rebol-MiniAudio/raw/refs/heads/master/assets/drumloop.wav
]

;; Initialize the first available playback device.
;; IMPORTANT: The device handle must be kept in a variable — if it goes out of
;; scope, the garbage collector will release it and playback will stop.
device: audio/init-playback 1

;; Load the audio file and print basic info about what we're about to play
sound: audio/load :file
print ["Play" number-of-sounds "overlaping loops:" to-local-file/full file]
print ["Sound duration:" sound/duration]

;; Build a block to track all loaded sound instances for later cleanup.
;; Each sound is loaded separately so they can play simultaneously (overlapping).
;; It is safe to call `audio/load` with the same file multiple times — the
;; extension manages instances internally, so no manual deduplication is needed.
;; Sounds are staggered in time: each one starts after the previous finishes,
;; plus the small delay, creating a cascading/phasing canon effect.
sounds: [] start-time: 0:0:0
loop number-of-sounds [
    append sounds sound: audio/load :file      ;; load a fresh instance
    audio/start/loop/at :sound :start-time     ;; schedule it to start at staggered time
    start-time: start-time + sound/duration + delay-between-sounds  ;; advance offset
]

;; Wait long enough for all staggered sounds to finish playing
wait sound/duration + start-time

print "Start stoping sounds..."

;; Gracefully stop each sound one at a time, using a fade-out equal to
;; the sound's own duration, then waiting for that fade to complete
;; before moving on to the next one.
while [not empty? sounds][
    sound: take sounds
    audio/stop/fade sound sound/duration  ;; fade out over one sound-duration
    wait sound/duration                   ;; wait for the fade to finish
]

print "Done"
;; Release the playback device now that all sounds have stopped
release device
