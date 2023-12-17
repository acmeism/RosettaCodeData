import "./fmt" for Fmt
import "./str" for Str

var table =
    "add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3 " +
    "compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate " +
    "3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2 " +
    "forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load " +
    "locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2 " +
    "msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3 " +
    "refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left " +
    "2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1"

var validate = Fn.new { |commands, words, minLens|
    var results = []
    if (words.count == 0) return results
    for (word in words) {
        var matchFound = false
        var wlen = word.count
        for (i in 0...commands.count) {
            var command = commands[i]
            if (minLens[i] != 0 && wlen >= minLens[i] && wlen <= command.count) {
                var c = Str.upper(command)
                var w = Str.upper(word)
                if (c.startsWith(w)) {
                    results.add(c)
                    matchFound = true
                    break
                }
            }
        }
        if (!matchFound) results.add("*error*")
    }
    return results
}

var splits = table.split(" ")
// get rid of empty entries
for (i in splits.count-1..0) if (splits[i] == "") splits.removeAt(i)
var slen = splits.count
var commands = []
var minLens = []
var i = 0
while (true) {
    commands.add(splits[i])
    var len = splits[i].count
    if (i == slen - 1) {
        minLens.add(len)
        break
    }
    i = i + 1
    var num = Num.fromString(splits[i])
    if (num != null) {
        minLens.add( (num < len) ? num : len )
        i = i + 1
        if (i == slen) break
    } else minLens.add(len)
}
var sentence = "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin"
var words = sentence.split(" ")
// get rid of empty entries
for (i in words.count-1..0) if (words[i] == "") words.removeAt(i)
var results = validate.call(commands, words, minLens)
System.write("user words:  ")
for (j in 0...words.count) {
    System.write("%(Fmt.s(-results[j].count, words[j])) ")
}
System.write("\nfull words:  ")
System.print(results.join(" "))
