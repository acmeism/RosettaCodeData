const table =
    "Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy " *
    "COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find " *
    "NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput " *
    "Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO " *
    "MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT " *
    "READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT " *
    "RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up "

function validate(commands::AbstractVector{<:AbstractString},
        minlens::AbstractVector{<:Integer}, words::AbstractVector{<:AbstractString})
    r = String[]
    for word in words
        matchfound = false
        for (i, command) in enumerate(commands)
            if iszero(minlens[i]) || length(word) ∉ minlens[i]:length(command)
                continue
            end
            if startswith(lowercase(command), lowercase(word))
                push!(r, uppercase(command))
                matchfound = true
                break
            end
        end
        !matchfound && push!(r, "*error*")
    end
    return r
end

commands = split(strip(table))
minlens  = count.(isupper, commands)
sentence = "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin"
words    = split(sentence)
result   = validate(commands, minlens, words)
println("User words: ", join(lpad.(words,  11)))
println("Full words: ", join(lpad.(result, 11)))
