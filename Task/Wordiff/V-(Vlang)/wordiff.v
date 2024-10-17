import os
import rand
import time
import arrays

fn is_wordiff(guesses []string, word string, dict []string) bool {
    if word !in dict {
        println("That word is not in the dictionary")
        return false
    }
    if word in guesses {
        println("That word has already been used")
        return false
    }
    if word.len < guesses[guesses.len-1].len {
        return is_wordiff_removal(word, guesses[guesses.len-1])
    } else if word.len > guesses[guesses.len-1].len {
        return is_wordiff_insertion(word, guesses[guesses.len-1])
    }
    return is_wordiff_change(word,guesses[guesses.len-1])
}
fn is_wordiff_removal(new_word string, last_word string) bool {
    for i in 0..last_word.len {
        if new_word == last_word[..i] + last_word[i+1..] {
            return true
        }
    }
    println("Word is not derived from previous by removal of one letter")
    return false
}
fn is_wordiff_insertion(new_word string, last_word string) bool {
    if new_word.len > last_word.len+1 {
        println("More than one character insertion difference")
        return false
    }
    mut a := new_word.split("")
    b := last_word.split("")
    for c in b {
        idx := a.index(c)
        if idx >=0 {
            a.delete(idx)
        }
    }
    if a.len >1 {
        println("Word is not derived from previous by insertion of one letter")
        return false
    }
    return true
}
fn is_wordiff_change(new_word string, last_word string) bool  {
    mut diff:=0
    for i,c in new_word {
        if c != last_word[i] {
            diff++
        }
    }
    if diff != 1 {
        println("More or less than exactly one character changed")
        return false
    }
    return true
}

fn main() {
    words := os.read_lines("unixdict.txt")?
    time_limit := os.input("Time limit (sec) or 0 for none: ").int()
    players := os.input("Please enter player names, separated by commas: ").split(",")

    dic_3_4 := words.filter(it.len in [3,4])
    mut wordiffs := rand.choose<string>(dic_3_4,1)?
    mut timing := [][]f64{len: players.len}
    start := time.now()
    mut turn_count := 0
    for {
        turn_start := time.now()
        word := os.input("${players[turn_count%players.len]}: Input a wordiff from ${wordiffs[wordiffs.len-1]}: ")
        if time_limit != 0.0 && time.since(start).seconds()>time_limit{
            println("TIMES UP ${players[turn_count%players.len]}")
            break
        } else {
            if is_wordiff(wordiffs, word, words) {
                wordiffs<<word
            }else{
                timing[turn_count%players.len] << time.since(turn_start).seconds()
                println("YOU HAVE LOST ${players[turn_count%players.len]}")
                break
            }
        }
        timing[turn_count%players.len] << time.since(turn_start).seconds()
        turn_count++
    }
    println("Timing ranks:")
    for i,p in timing {
        sum := arrays.sum<f64>(p) or {0}
        println("  ${players[i]}: ${sum/p.len:10.3 f} seconds average")
    }
}
