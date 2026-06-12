function piglatinize(str::AbstractString)
    if isempty(str) || all(isspace, str)
        str
    elseif !isletter(first(str))
        first(str) * piglatinize(str[(begin+1):end])
    elseif !isletter(last(str))
        piglatinize(str[begin:(end-1)]) * last(str)
    elseif contains(str, r"\s")
        m = match(r"^(\S+)(\s+)(.*)$", str)
        piglatinize(m.captures[1]) * m.captures[2] * piglatinize(m.captures[3])
    elseif first(str) ∈ "aeiouAEIOU" ||
           (m = match(r"^([^aeiouAEIOU][^aeiouyAEIOUY]*)(.*)", str)) === nothing
        str * (alluppercaseletters(str) ? "WAY" : "way")
    else
        stop, start = m.captures
        if stop[begin] ∈ "qQ" && !isempty(start) && start[begin] ∈ "uU"
            stop = stop * start[begin]
            start = string(start[(begin+1):end])
        end
        if isempty(start) && last(stop) ∈ "yY"
            start = string(last(stop))
            stop = string(stop[begin:(end-1)])
        end
        if alluppercaseletters(start) && alluppercaseletters(stop)
            start * stop * "AY"
        else
            if isuppercase(first(str))
                start = uppercasefirst(start)
                stop = lowercasefirst(stop)
            end
            start * stop * "ay"
        end
    end
end

alluppercaseletters(s::AbstractString) = all(c -> !isletter(c) || isuppercase(c), s)

for (input, expected) in zip(
    [
        "",
        " ",
        "123456!",
        "Stop! In the name of Wuv!",
        "My word!",
        "pig  latin",
        "rosetta code",
        "the quick brown fox jumps over the lazy dog",
        "by the way",
        "pig",
        "black",
        "a",
        "open",
        "Flower",
        "yellow",
        "bypass",
        "apple",
        "Igloo",
        "string",
        "Hamburger",
        "Rhythm",
        "queen",
        "zippity",
        "egg",
        "Pig",
        "Latin",
        "trash",
        "quit",
        "BaNaNa",
        "DNa",
        "plover",
        "plunder",
        "And now for something completely different!",
        "Stwike him, centuwion, stwike him vewy wuffly",
        "Images",
        "Blogger",
        "Sign In",
        "he does not know",
        "banana",
        "hello world",
        "Hello, World!",
        "ALL CAPITALS",
        "gypsy",
        "o'hare O'HARE o'hare don't",
        "K?",
        "mind ypur p's and q",
        "'ulu"],
    [
        "",
        " ",
        "123456!",
        "Opstay! Inway ethay amenay ofway Uvway!",
        "Ymay ordway!",
        "igpay  atinlay",
        "osettaray odecay",
        "ethay ickquay ownbray oxfay umpsjay overway ethay azylay ogday",
        "ybay ethay ayway",
        "igpay",
        "ackblay",
        "away",
        "openway",
        "Owerflay",
        "ellowyay",
        "ypassbay",
        "appleway",
        "Iglooway",
        "ingstray",
        "Amburgerhay",
        "Ythmrhay",
        "eenquay",
        "ippityzay",
        "eggway",
        "Igpay",
        "Atinlay",
        "ashtray",
        "itquay",
        "ANaNabay",
        "AdNay",
        "overplay",
        "underplay",
        "Andway ownay orfay omethingsay ompletelycay ifferentday!",
        "Ikestway imhay, entuwioncay, ikestway imhay ewyvay ufflyway",
        "Imagesway",
        "Oggerblay",
        "Ignsay Inway",
        "ehay oesday otnay owknay",
        "ananabay",
        "ellohay orldway",
        "Ellohay, Orldway!",
        "ALLWAY APITALSCAY",
        "ypsygay",
        # NB: decided to treat <O'HARE> as one word and preserve the all uppercase even with apostrophe
        """o'hareway O'HAREWAY o'hareway on'tday""",
        "KAY?",
        "indmay urypay p'say andway qay",
        "'uluway",
    ])
    result = piglatinize(input)
    @assert result == expected "For input: '$input', expected: '$expected', got: '$result'"
end
@info "All tests passed!"
