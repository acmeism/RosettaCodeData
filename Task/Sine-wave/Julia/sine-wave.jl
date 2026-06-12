using PortAudio

function paudio()
    devs = PortAudio.devices()
    devnum = findfirst(x -> x.maxoutchans > 0, devs)
    (devnum == nothing) && error("No output device for audio found")
    return ostream = PortAudioStream(devs[devnum].name, 0, 2)
end

function play(ostream, pitch, durationseconds)
    sinewave(t) = 0.6sin(t) + 0.2sin(2t) + .05sin(8t)
    timesamples = 0:(1 / 44100):(durationseconds * 0.98)
    v = Float64[sinewave(2π * pitch * t) for t in timesamples]
    write(ostream, v)
    sleep(durationseconds * 0.9)
end

play(paudio(), 440.0, 5.0)
