using Dates

function syncsubtitles(intext::AbstractString, sec::Integer, msec::Integer)
    outtext, fmt = "", dateformat"HH:MM:SS,sss"
    deltatime = Dates.Second(sec) + Dates.Millisecond(msec)
    for line in split(intext, r"\r?\n")
        if !isempty(line) && length(begin times = split(line, " --> ") end) == 2
            start, stop = DateTime.(times, fmt) .+ deltatime
            line = join(Dates.format.((start, stop), fmt), " ==> ")
        end
        outtext *= line * "\n"
    end
    return outtext
end

function syncsubtitles(infile, outfile::AbstractString, sec, msec = 0)
    outs = open(outfile, "w")
    write(outs, syncsubtitles(read(infile, String), sec, msec))
    close(outs)
end

println("After fast-forwarding 9 seconds:\n")
syncsubtitles("movie.srt", "movie_corrected.srt", 9)
println(read("movie_corrected.srt", String))
println("After rolling-back 9 seconds:\n")
syncsubtitles("movie.srt", "movie_corrected2.srt", -9)
println(read("movie_corrected2.srt", String))
