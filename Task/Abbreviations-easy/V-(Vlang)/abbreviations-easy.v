import encoding.utf8

fn validate(commands []string, words []string, min_len []int) []string {
    mut results := []string{}
    if words.len == 0 {
        return results
    }
    for word in words {
        mut match_found := false
        wlen := word.len
        for i, command in commands {
            if min_len[i] == 0 || wlen < min_len[i] || wlen > command.len {
                continue
            }
            c := utf8.to_upper(command)
            w := utf8.to_upper(word)
            if c.index(w) or {-1} ==0 {
                results << c
                match_found = true
                break
            }
        }
        if !match_found {
            results << "*error*"
        }
    }
    return results
}

fn main() {
mut table := "Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy " +
    "COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find " +
    "NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput " +
     "Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO " +
    "MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT " +
    "READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT " +
    "RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up "
    table = table.trim_space()
    commands := table.fields()
    clen := commands.len
    mut min_len := []int{len: clen}
    for i in 0..clen {
        mut count := 0
        for c in commands[i].split('') {
            if c >= 'A' && c <= 'Z' {
                count++
            }
        }
        min_len[i] = count
    }
    sentence :=  "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin"
    words := sentence.fields()
    results := validate(commands, words, min_len)
    for j in 0..words.len {
        print("${words[j]} ")
    }
    print("\nfull words:  ")
    println(results.join(" "))
}
