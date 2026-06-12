using DSP, FileIO, LibSndFile

const soundfilename = "Cscale3octaves.wav"
const freq_to_solfa = Dict([
130.81 => "DOH"
146.83 => "RAY"
164.81 => "MEE"
174.61 => "FAH"
196.0 => "SOH"
220.0 => "LAH"
246.94 => "TEE"
261.63 => "Doh"
293.66 => "Ray"
329.63 => "Mee"
349.23 => "Fah"
392.0 => "Soh"
440.0 => "Lah"
493.88 => "Tee"
523.25 => "doh"
587.33 => "ray"
659.25 => "mee"
698.46 => "fah"
783.99 => "soh"
880.0 => "lah"
987.77 => "tee"
])
const sfreqs = sort(collect(keys(freq_to_solfa)))

function closestfreqs(samples, fs=44100.0)
    pfreqs = Float64[]
    for sample in samples
        M = div(length(sample) + 1, 3)
        arr = [Complex{Float64}(x) for x in sample]
        narr = filter(x -> x > 0, esprit(arr, M, 4, fs))
        idx = argmin([abs(f - narr[end]) for f in sfreqs])
        push!(pfreqs, sfreqs[idx])
    end
    return pfreqs
end

function getchunks(soundfile, channel=1, timespan=0.1)
    sv = load(soundfile)
    fs = LibSndFile.samplerate(sv)
    samplespan, data = Int(round(timespan * fs)), view(sv, :, channel)
    return (fs, [data[i:i+samplespan-1] for i in 1:samplespan:length(data)-samplespan-1])
end

function makenotelist(soundfile, repetitionsneeded=2)
    changelist = String[]
    fs, samples = getchunks(soundfile)
    freqs = closestfreqs(samples, fs)
    reps, prev = 0, ""
    for freq in freqs
        note = freq_to_solfa[freq]
        if note != prev
            prev = note
            reps = 0
        else
            reps += 1
            if reps == repetitionsneeded
               push!(changelist, note)
            end
        end
    end
    return changelist
end

println(makenotelist(soundfilename))

