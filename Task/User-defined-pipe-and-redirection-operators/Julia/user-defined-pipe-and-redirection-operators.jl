const LISTDATA = """
Wil van der Aalst	business process management, process mining, Petri nets
Hal Abelson	intersection of computing and teaching
Serge Abiteboul	database theory
Samson Abramsky	game semantics
Leonard Adleman	RSA, DNA computing
Manindra Agrawal	polynomial-time primality testing
Luis von Ahn	human-based computation
Alfred Aho	compilers book, the 'a' in AWK
Stephen R. Bourne	Bourne shell, portable ALGOL 68C compiler
Kees Koster	ALGOL 68
Lambert Meertens	ALGOL 68, ABC (programming language)
Peter Naur	BNF, ALGOL 60
Guido van Rossum	Python (programming language)
Adriaan van Wijngaarden	Dutch pioneer; ARRA, ALGOL
Dennis E. Wisnosky	Integrated Computer-Aided Manufacturing (ICAM), IDEF
Stephen Wolfram	Mathematica
William Wulf	compilers
Edward Yourdon	Structured Systems Analysis and Design Method
Lotfi Zadeh	fuzzy logic
Arif Zaman	Pseudo-random number generator
Albert Zomaya	Australian pioneer of scheduling in parallel and distributed systems
Konrad Zuse	German pioneer of hardware and software
"""

datafilename = "List_of_computer_scientists.lst"
stat(datafilename).size == 0 && (fd = open(datafilename, "a"); write(fd, LISTDATA); close(fd))

channelstream() = Channel{String}(200)
closewhenempty(c) = @async begin while !isempty(c) sleep(rand()) end; close(c); end

function head(filename, numlines, chan=channelstream())
    fd = open(filename)
    buffer = String[]
    while !eof(fd)
        push!(buffer, readline(fd, keep=true))
        length(buffer) == numlines && break
    end
    close(fd)
    @async begin
        for line in buffer
            put!(chan, line)
        end
        closewhenempty(chan)
    end
    return chan
end

function cat(filename::AbstractString, chan=channelstream())
    @async begin
        fd = open(filename)
        while !eof(fd)
            put!(chan, readline(fd, keep=true))
        end
        close(fd)
        closewhenempty(chan)
    end
    return chan
end

function grep(inchan::Channel, target, outchan = channelstream())
    @async begin
        try
            while isopen(inchan)
                line = take!(inchan)
                if occursin(target, line)
                    put!(outchan, line)
                end
            end
        catch;
        end
        closewhenempty(outchan)
    end
    return outchan
end
grep(target) = (chan) -> grep(chan, target)

function tee(inchan::Channel, filename, outchan=channelstream())
    fd = open(filename, "w")
    @async begin
        while isopen(inchan)
            try
                line = take!(inchan)
                write(fd, line)
                put!(outchan, line)
            catch;
                break
            end
        end
        close(fd)
        closewhenempty(outchan)
    end
    return outchan
end
tee(filename, outchan=channelstream()) = (inchan) -> tee(inchan, filename, outchan)

function tail(filename, numlines, chan=channelstream())
    fd = open(filename)
    buffer = String[]
    while !eof(fd)
        push!(buffer, readline(fd, keep=true))
        length(buffer) > numlines && popfirst!(buffer)
    end
    @async begin
        for line in buffer
            put!(chan, line)
        end
        closewhenempty(chan)
    end
    return chan
end

function Sort(inchan, outchan = channelstream())
    buffer = String[]
    try
        while isopen(inchan)
            push!(buffer, take!(inchan))
        end
    catch;
    end
    @async begin
        for line in sort!(buffer)
            put!(outchan, line)
        end
        closewhenempty(outchan)
    end
    return outchan
end
Sort() = (chan) -> Sort(chan)

function uniq(inchan, outchan = channelstream())
    alreadyseen = Set{String}()
    @async begin
        while isopen(inchan)
            try
                line = take!(inchan)
                if !(line in alreadyseen)
                    push!(alreadyseen, line)
                    put!(outchan, line)
                end
            catch;
                break
            end
        end
        closewhenempty(outchan)
    end
    return outchan
end
uniq() = (chan) -> uniq(chan)

function print_lines(chan)
    @async begin
        while isopen(chan)
            line = take!(chan)
            print(line)
        end
    end
end
print_lines() = (chan) -> print_lines(chan)

const commonoutchan = channelstream()

head("List_of_computer_scientists.lst", 4, commonoutchan)

cat("List_of_computer_scientists.lst") |> grep("ALGOL") |> tee("Algol_pioneers.lst", commonoutchan)

tail("List_of_computer_scientists.lst", 4, commonoutchan)

Sort(commonoutchan) |> uniq() |> tee("the_important_scientists.lst") |>
    grep("aa") |> print_lines()
