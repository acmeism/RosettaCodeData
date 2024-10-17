#1
natural1(x, y) = strip(x) < strip(y)

#2
natural2(x, y) = replace(x, r"\s+" => " ") < replace(y, r"\s+" => " ")

#3
natural3(x, y) = lowercase(x) < lowercase(y)

#4
splitbynum(x) = split(x, r"(?<=\D)(?=\d)|(?<=\d)(?=\D)")
numstringtonum(arr) = [(n = tryparse(Float32, e)) != nothing ? n : e for e in arr]
function natural4(x, y)
    xarr = numstringtonum(splitbynum(x))
    yarr = numstringtonum(splitbynum(y))
    for i in 1:min(length(xarr), length(yarr))
        if typeof(xarr[i]) != typeof(yarr[i])
            a = string(xarr[i]); b = string(yarr[i])
        else
             a = xarr[i]; b = yarr[i]
        end
        if a == b
            continue
        else
            return a < b
        end
    end
    return length(xarr) < length(yarr)
end

#5
deart(x) = replace(x, r"^The\s+|^An\s+|^A\s+"i => "")
natural5(x, y) = deart(x) < deart(y)

#6
const accentdict = Dict(
'À'=> 'A', 'Á'=> 'A', 'Â'=> 'A', 'Ã'=> 'A', 'Ä'=> 'A',
'Å'=> 'A', 'Ç'=> 'C', 'È'=> 'E', 'É'=> 'E',
'Ê'=> 'E', 'Ë'=> 'E', 'Ì'=> 'I', 'Í'=> 'I', 'Î'=> 'I',
'Ï'=> 'I', 'Ñ'=> 'N', 'Ò'=> 'O', 'Ó'=> 'O',
'Ô'=> 'O', 'Õ'=> 'O', 'Ö'=> 'O', 'Ù'=> 'U', 'Ú'=> 'U',
'Û'=> 'U', 'Ü'=> 'U', 'Ý'=> 'Y', 'à'=> 'a', 'á'=> 'a',
'â'=> 'a', 'ã'=> 'a', 'ä'=> 'a', 'å'=> 'a', 'è'=> 'e',
'é'=> 'e', 'ê'=> 'e', 'ë'=> 'e', 'ì'=> 'i', 'í'=> 'i',
'î'=> 'i', 'ï'=> 'i', 'ð'=> 'd', 'ñ'=> 'n', 'ò'=> 'o',
'ó'=> 'o', 'ô'=> 'o', 'õ'=> 'o', 'ö'=> 'o', 'ù'=> 'u',
'ú'=> 'u', 'û'=> 'u', 'ü'=> 'u', 'ý'=> 'y', 'ÿ'=> 'y')
function tr(str, dict=accentdict)
    for (i, ch) in enumerate(str)
        if haskey(dict, ch)
            arr = split(str, "")
            arr[i] = string(dict[ch])
            str = join(arr)
        end
    end
    str
end

natural6(x, y) = tr(x) < tr(y)

#7
const ligaturedict = Dict('œ' => "oe", 'Œ' => "OE", 'æ' => "ae", 'Æ' => "AE", 'Ĳ' => "IJ")
natural7(x, y) = tr(x, ligaturedict) < tr(y, ligaturedict)

#8
const altsdict = Dict('ß' => "ss", 'ſ' => 's', 'ʒ' => 's')
natural8(x, y) = tr(x, altsdict) < tr(y, altsdict)

preprocessors = [natural1, natural2, natural2, natural3, natural4, natural5, natural6, natural7, natural8]

const testarrays = Vector{Vector{String}}([
["ignore leading spaces: 2-2", " ignore leading spaces: 2-1", "  ignore leading spaces: 2+0", "   ignore leading spaces: 2+1"],
["ignore m.a.s spaces: 2-2", "ignore m.a.s  spaces: 2-1", "ignore m.a.s   spaces: 2+0", "ignore m.a.s    spaces: 2+1"],
["Equiv. spaces: 3-3", "Equiv.\rspaces: 3-2", "Equiv.\x0cspaces: 3-1", "Equiv.\x0bspaces: 3+0", "Equiv.\nspaces: 3+1", "Equiv.\tspaces: 3+2"],
["cASE INDEPENENT: 3-2", "caSE INDEPENENT: 3-1", "casE INDEPENENT: 3+0", "case INDEPENENT: 3+1"],
["foo100bar99baz0.txt", "foo100bar10baz0.txt", "foo1000bar99baz10.txt", "foo1000bar99baz9.txt"],
["The Wind in the Willows", "The 40th step more", "The 39 steps", "Wanda"],
["Equiv. ý accents: 2-2", "Equiv. Ý accents: 2-1", "Equiv. y accents: 2+0", "Equiv. Y accents: 2+1"],
["Ĳ ligatured ij", "no ligature"],
["Start with an ʒ: 2-2", "Start with an ſ: 2-1", "Start with an ß: 2+0", "Start with an s: 2+1"]])

for (i, ltfunction) in enumerate(preprocessors)
    println("Testing sorting mod number $i. Sorted is: $(sort(testarrays[i], lt=ltfunction)).")
end
