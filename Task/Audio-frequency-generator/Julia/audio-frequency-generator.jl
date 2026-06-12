using PortAudio

if Sys.iswindows()
    getch() = @threadcall((:_getch, "msvcr100.dll"), Cint, ())
else
    getch() = @threadcall((:getch, libcurses), Cint, ())
end

function audiodevices()
    println(rpad("Index", 6), rpad("Device Name", 44), rpad("API", 16), rpad("In", 4),
        rpad("Out", 4), rpad("Sample Rate", 8))
    for (i, dev) in enumerate(PortAudio.devices())
        println(rpad(i - 1, 6), rpad(dev.name, 44), rpad(dev.hostapi, 16),
            rpad(dev.maxinchans, 4), rpad(dev.maxoutchans, 4),
            rpad(dev.defaultsamplerate, 8))
    end
end

println("Listing available hardware:")
audiodevices()

function paudio()
    devs = PortAudio.devices()
    devnum = findfirst(x -> x.maxoutchans > 0, devs)
    (devnum == nothing) && error("No output device for audio found")
    println("Enter a device # from the above, or Enter for default: ")
    n = tryparse(Int, strip(readline()))
    devnum = n == nothing ? devnum : n + 1
    return PortAudioStream(devs[devnum].name, 0, 2)
end

play(ostream, sample::Array{Float64,1}) = write(ostream, sample)
play(ostr, sample::Array{Int64,1}) = play(ostr, Float64.(sample))

struct Note{S<:Real, T<:Real}
    pitch::S
    duration::T
    volume::T
    sustained::Bool
end

sinewave(t) = 0.6sin(t) + 0.2sin(2t) + .05*sin(8t)
squarewave(t) = iseven(Int(trunc(t / π))) ? 1.0 : -1.0
sawtoothwave(t) = rem(t, 2π)/π - 1

function play(ostream, A::Note, samplingfreq::Real=44100, shape::Function=sinewave, pause=true)
    timesamples = 0:(1 / samplingfreq):(A.duration * (A.sustained ? 0.98 : 0.9))
    v = Float64[shape(2π * A.pitch * t) for t in timesamples]
    if !A.sustained
        decay_length = div(length(timesamples), 5)
        v[end-decay_length:end-1] = v[end-decay_length:end-1] .* LinRange(1, 0, decay_length)
    end
    v .*= A.volume
    play(ostream, v)
    if pause
        sleep(A.duration)
    end
end

function inputtask(channel)
    println("""
    \nAllow several seconds for settings changes to take effect.
    Arrow keys:
    Volume up: up Volume down: down Frequency up: right Frequency down: left
    Sine wave(default): s Square wave: a  Sawtooth wave: w
    To exit: x
    """)
    while true
        inputch = Char(getch())
        if inputch == 'à'
            inputch = Char(getch())
        end
        put!(channel, inputch)
        sleep(0.2)
    end
end

function playtone(ostream)
    volume = 0.5
    pitch = 440.0
    waveform = sinewave
    while true
        if isready(chan)
            ch = take!(chan)
            if ch == 'H'
                volume = min(volume * 2.0, 1.0)
            elseif ch == 'P'
                volume = max(volume * 0.5, 0.0)
            elseif ch == 'M'
                pitch = min(pitch * 9/8, 20000)
            elseif ch == 'K'
                pitch = max(pitch * 7/8, 32)
            elseif ch == 's'
                waveform = sinewave
            elseif ch == 'a'
                waveform = squarewave
            elseif ch == 'w'
                waveform = sawtoothwave
            elseif ch == 'x'
                break
            end
        end
        play(ostream, Note(pitch, 4.5, volume, true), 44100.0, waveform, false)
    end
    exit()
end

const ostr = paudio()
const chan = Channel{Char}(1)
const params = Any[]

@async(inputtask(chan))
playtone(ostr)
