print("Enter seconds to wait: ")
(secs = tryparse(Int, readline())) == nothing && (secs = 10)

print("Enter an mp3 filename: ")
soundfile = strip(readline())

match(r"\.mp3$", soundfile) == nothing && (soundfile = soundfile * ".mp3")
(filesize(soundfile) == 0) && (soundfile = "default.mp3")

sleep(secs)
run(`play "$soundfile"`)
