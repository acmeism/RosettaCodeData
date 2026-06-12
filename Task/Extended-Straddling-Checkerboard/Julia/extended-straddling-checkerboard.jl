const row1, row2, row3, row4 = "AEINOT", "BCDFGHJKLM", "PQRSUVWXYZ", " ."
const emap = Dict{String,String}()
for (row, k) in [(row1, -1), (row2, 69), (row3, 79), (row4, 89)]
    for i in eachindex(row)
        emap[string(row[i])] = string(i + k)
    end
end
const dmap = Dict{String,String}(v => k for (k, v) in emap)

const ewords = Dict{String,String}(
    "ACK" => "92",
    "REQ" => "93",
    "MSG" => "94",
    "RV" => "95",
    "GRID" => "96",
    "SEND" => "97",
    "SUPP" => "99",
)
const dwords = Dict{String,String}(v => k for (k, v) in ewords)

const efigs, spc, dot, fsl, drow1 = "0123456789", "90", "91", "98", "012345"

function encode(s)
    s, res = uppercase(s), ""
    words = split(s, r"\s")
    wc = length(words)
    for i = 1:wc
        word, add = words[i], ""
        if haskey(ewords, word)
            add = ewords[word]
        elseif haskey(ewords, word[begin:end-1]) && word[end] == "."
            add = ewords[word[begin:end-1]] * dot
        elseif startswith(word, "CODE")
            add = "6" * word[begin+4:end]
        else
            figs = false
            for c in word
                if contains(efigs, c)
                    if figs
                        add *= c^2
                    else
                        figs = true
                        add *= fsl * c^2
                    end
                else
                    ec = get(emap, string(c), "")
                    isempty(ec) && error("Message contains unrecognized character $c.")
                    if figs
                        add *= fsl * ec
                        figs = false
                    else
                        add *= ec
                    end
                end
            end
            if figs && i <= wc - 1
                add *= fsl
            end
        end
        res *= add
        if i <= wc - 1
            res *= spc
        end
    end
    return res
end

function decode(s)
    res, sc, figs, i = "", length(s), false, 1
    while i <= sc
        ch = s[i]
        c = string(ch)
        if figs
            if s[i:i+1] != fsl
                res *= c
                i += 2
            else
                figs = false
                i += 2
            end
        elseif !((ix = findfirst(==(ch), drow1)) isa Nothing)
            res *= dmap[string(drow1[ix])]
            i += 1
        elseif c == "6"
            res *= "CODE" * s[i+1:i+3]
            i += 4
        elseif c == "7" || c == "8"
            d = string(s[i+1])
            res *= dmap[c*d]
            i += 2
        elseif c == "9"
            d = string(s[i+1])
            if d == "0"
                res *= " "
            elseif d == "1"
                res *= "."
            elseif d == "8"
                figs = !figs
            else
                res *= dwords[c*d]
            end
            i += 2
        end
    end
    return res
end

const msg = "Admin ACK your MSG. CODE291 SEND further 2000 SUPP to HQ by 1 March"
println("Message:\n$msg")
enc = encode(msg)
println("\nEncoded:\n$enc")
dec = decode(enc)
println("\nDecoded:\n$dec")
