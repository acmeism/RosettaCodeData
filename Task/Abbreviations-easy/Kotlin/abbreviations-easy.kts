// version 1.1.4-3

val r = Regex("[ ]+")

val table =
    "Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy " +
    "COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find " +
    "NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput " +
    "Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO " +
    "MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT " +
    "READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT " +
    "RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up "

fun validate(commands: List<String>, minLens: List<Int>, words: List<String>): List<String> {
    if (words.isEmpty()) return emptyList<String>()
    val results = mutableListOf<String>()
    for (word in words) {
        var matchFound = false
        for ((i, command) in commands.withIndex()) {
            if (minLens[i] == 0 || word.length !in minLens[i] .. command.length) continue
            if (command.startsWith(word, true)) {
                results.add(command.toUpperCase())
                matchFound = true
                break
            }
        }
        if (!matchFound) results.add("*error*")
    }
    return results
}

fun main(args: Array<String>) {
    val commands = table.trimEnd().split(r)
    val minLens = MutableList(commands.size) { commands[it].count { c -> c.isUpperCase() } }
    val sentence = "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin"
    val words = sentence.trim().split(r)
    val results = validate(commands, minLens, words)
    print("user words:  ")
    for (j in 0 until words.size) print("${words[j].padEnd(results[j].length)} ")
    print("\nfull words:  ")
    for (j in 0 until results.size) print("${results[j]} ")
    println()
}
