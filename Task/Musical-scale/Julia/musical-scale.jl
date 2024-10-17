using PortAudio

function paudio()
    devs = PortAudio.devices()
    devnum = findfirst(x -> x.maxoutchans > 0, devs)
    (devnum == nothing) && error("No output device for audio found")
    return PortAudioStream(devs[devnum].name, 0, 2)
end

function play(ostream, pitch, durationseconds)
    sinewave(t) = 0.6sin(t) + 0.2sin(2t) + .05sin(8t)
    timesamples = 0:(1 / 44100):(durationseconds * 0.98)
    v = Float64[sinewave(2π * pitch * t) for t in timesamples]
    write(ostream, v)
    sleep(durationseconds * 0.9)
end

# C major scale starting with middle C
# pitches from //pages.mtu.edu/~suits/notefreqs.html
const scale = [261.6, 293.7, 329.6, 349.2, 392, 440, 493.9, 523.3]
const ostream = paudio()
for pitch in scale
    play(ostream, pitch, 0.5)
    sleep(0.4)
end
