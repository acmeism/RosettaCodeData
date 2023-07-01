const commandtable = """
add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3
compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate
3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2
forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load
locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2
msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3
refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left
2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1"""

function makedict(tbl)
    str = split(uppercase(tbl), r"\s+")
    dict = Dict{String, String}()
    for (i, s) in enumerate(str)
        if (n = tryparse(Int, s)) != nothing
            dict[str[i-1][1:n]] = str[i-1]
        else
            dict[s] = s
        end
    end
    dict
end

function okabbrev(dict, abb)
    for i in length(abb):-1:1
        if haskey(dict, abb[1:i])
            com = dict[abb[1:i]]
            if length(abb) <= length(com) && abb == com[1:length(abb)]
                return dict[abb[1:i]]
            end
        end
    end
    return "*error*"
end

formattedprint(arr, n) =  (for s in arr print(rpad(s, n)) end; println())

function teststring(str)
    d = makedict(commandtable)
    commands = split(str, r"\s+")
    formattedprint(commands, 9)
    formattedprint([okabbrev(d, uppercase(s)) for s in commands], 9)
end

teststring("riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin")
