isoneless(nw, ow) = any(i -> nw == ow[begin:i-1] * ow[i+1:end], eachindex(ow))
isonemore(nw, ow) = isoneless(ow, nw)
isonechanged(x, y) = length(x) == length(y) && count(i -> x[i] != y[i], eachindex(y)) == 1
onefrom(nw, ow) = isoneless(nw, ow) || isonemore(nw, ow) || isonechanged(nw, ow)

function askprompt(prompt)
    ans = ""
    while isempty(ans)
        print(prompt)
        ans = strip(readline())
    end
    return ans
end

function wordiff(dictfile = "unixdict.txt")
    wordlist = [w for w in split(read(dictfile, String), r"\s+") if !occursin(r"\W", w) && length(w) > 2]
    starters = [w for w in wordlist if 3 <= length(w) <= 4]

    timelimit = something(tryparse(Float64, askprompt("Time limit (min) or 0 for none: ")), 0.0)

    players = split(askprompt("Enter players' names. Separate by commas: "), r"\s*,\s*")
    times, word = Dict(player => Float32[] for player in players), rand(starters)
    used, totalsecs, timestart = [word], timelimit * 60, time()
    while length(players) > 1
        player = popfirst!(players)
        playertimestart = time()
        newword = askprompt("$player, your move. The current word is $word.  Your worddiff? ")
        if timestart + totalsecs > time()
            if onefrom(newword, word) && !(newword in used) && lowercase(newword) in wordlist
                println("Correct.")
                push!(players, player)
                word = newword
                push!(used, newword)
                push!(times[player], time() - playertimestart)
            else
                println("Wordiff choice incorrect. Player $player exits game.")
            end
        else  # out of time
            println("Sorry, time was up. Timing ranks for remaining players:")
            avtimes = Dict(p => isempty(times[p]) ? NaN : sum(times[p]) / length(times[p])
                for p in players)
            sort!(players, lt = (x, y) -> avtimes[x] < avtimes[y])
            foreach(p -> println("    $p:", lpad(avtimes[p], 10), " seconds average"), players)
            break
        end
        sleep(rand() * 3)
    end
    length(players) < 2 && println("Player $(first(players)) is the only one left, and wins the game.")
end

wordiff()
