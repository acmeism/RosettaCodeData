import encoding.utf8
import strconv
fn read_table(table string) ([]string, []int) {
    fields := table.fields()
    mut commands := []string{}
    mut min_lens := []int{}

    for i, max := 0, fields.len; i < max; {
        cmd := fields[i]
        mut cmd_len := cmd.len
        i++

        if i < max {
            num := strconv.atoi(fields[i]) or {-1}
            if 1 <= num && num < cmd_len {
                cmd_len = num
                i++
            }
        }
        commands << cmd
        min_lens << cmd_len
    }
    return commands, min_lens
}

fn validate_commands(commands []string, min_lens []int, words []string) []string {
    mut results := []string{}
    for word in words {
        mut match_found := false
        wlen := word.len
        for i, command in commands {
            if min_lens[i] == 0 || wlen < min_lens[i] || wlen > command.len {
                continue
            }
            c := utf8.to_upper(command)
            w := utf8.to_upper(word)
            if c.index(w) or {-1} == 0 {
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

fn print_results(words []string, results []string) {
    println("user words:\t${words.join("\t")}")
    println("full words:\t${results.join("\t")}")
}

fn main() {
    table := "" +
    "add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3 " +
    "compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate " +
    "3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2 " +
    "forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load " +
    "locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2 " +
    "msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3 " +
    "refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left " +
    "2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1 "

    sentence := "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin"

    commands, min_lens := read_table(table)
    words := sentence.fields()

    results := validate_commands(commands, min_lens, words)

    print_results(words, results)
}
