module BaconCipher

using Formatting, IterTools.chain

const text = """All children, except one, grow up. They soon know that they will grow
    up, and the way Wendy knew was this. One day when she was two years old
    she was playing in a garden, and she plucked another flower and ran with
    it to her mother. I suppose she must have looked rather delightful, for
    Mrs. Darling put her hand to her heart and cried, "Oh, why can't you
    remain like this for ever!" This was all that passed between them on
    the subject, but henceforth Wendy knew that she must grow up. You always
    know after you are two. Two is the beginning of the end.

    Of course they lived at 14 [their house number on their street], and
    until Wendy came her mother was the chief one. She was a lovely lady,
    with a romantic mind and such a sweet mocking mouth. Her romantic
    mind was like the tiny boxes, one within the other, that come from the
    puzzling East, however many you discover there is always one more; and
    her sweet mocking mouth had one kiss on it that Wendy could never get,
    though there it was, perfectly conspicuous in the right-hand corner.""" |> lowercase

const byte = FormatSpec("05b")
const lc2bin = Dict{Char,String}(ch => fmt(byte, i) for (i, ch) in
    enumerate(chain('a':'z', '.', ' ')))
const bin2lc = Dict{String,Char}(v => k for (k, v) in lc2bin)

to5binary(msg::AbstractString) = collect(ch == '1' for lt in lowercase(msg) for ch in get(lc2bin, lt, ""))

function encrypt(msg::AbstractString, text::AbstractString=text)::String
    bin5 = to5binary(msg)
    tlist = collect(Char, lowercase(text))
    out = IOBuffer()
    for capitalise in bin5
        while !isempty(tlist)
            ch = shift!(tlist)
            if isalpha(ch)
                if capitalise
                    ch = uppercase(ch)
                end
                print(out, ch)
                break
            else
                print(out, ch)
            end
        end
    end
    println(out, "...")
    return take!(out)
end

function decrypt(text::AbstractString)::String
    binary = Char[]
    out    = IOBuffer()
    for ch in text
        if isalpha(ch)
            push!(binary, ifelse(isupper(ch), '1', '0'))
            if length(binary) == 5
                print(out, bin2lc[join(binary)])
                empty!(binary)
            end
        end
    end
    return take!(out)
end

end  # module BaconCipher
