import os

fn main() {
    mut result :=''
    unixdict := os.read_file('./unixdict.txt') or {panic('file not found')}
    for idx, word in neighbour(unixdict) {
        if ((idx + 1) % 6 == 0) == true {result += '$word \n'} else {result += '$word '}
    }
    println(result)
}

fn neighbour(list string) []string {
    mut word_arr, mut res_arr := []string{}, []string{}
    mut word_exist := map[string]bool
    mut new_word :=''
    for word in list.split_into_lines() {
        if word.len >= 9 {
            word_arr << word
            word_exist[word] = true
        }
    }
    for out_idx in 0..word_arr.len - 9 {
        new_word =''
        for in_idx in 0..9 {
            new_word += word_arr[out_idx + in_idx].substr(in_idx, in_idx + 1)
            if word_exist[new_word] == true && res_arr.any(it == new_word) == false {res_arr << new_word}
            }
    }
    return res_arr
}
