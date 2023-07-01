import "/fmt" for Fmt
import "/str" for Str

var table =
    "Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy " +
    "COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find " +
    "NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput " +
     "Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO " +
    "MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT " +
    "READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT " +
    "RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up"

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

var commands = table.split(" ")
// get rid of empty entries
for (i in commands.count-1..0) if (commands[i] == "") commands.removeAt(i)
var clen = commands.count
var minLens = [0] * clen
for (i in 0...clen) {
    var count = 0
    for (c in commands[i].codePoints) {
        if (c >= 65 && c <= 90) count = count + 1 // A to Z
    }
    minLens[i] = count
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
