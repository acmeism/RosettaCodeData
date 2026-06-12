SDL = require "SDL"
mixer = require "SDL.mixer"
lfs = require "lfs"

print("Enter a number of seconds: ")
sec = tonumber(io.read())
print("Enter the MP3 file to be played")
mp3filepath = lfs.currentdir() .. "/" .. io.read() .. ".mp3"

mixer.openAudio(44100, SDL.audioFormat.S16, 1, 1024)
Music = mixer.loadMUS(mp3filepath)
Music:play(1)

print("Press Enter to quit")
io.read()
