const text = "Given\$a\$text\$file\$of\$many\$lines,\$where\$fields\$within\$a\$line\$
are\$delineated\$by\$a\$single\$'dollar'\$character,\$write\$a\$program
that\$aligns\$each\$column\$of\$fields\$by\$ensuring\$that\$words\$in\$each\$
column\$are\$separated\$by\$at\$least\$one\$space.
Further,\$allow\$for\$each\$word\$in\$a\$column\$to\$be\$either\$left\$
justified,\$right\$justified,\$or\$center\$justified\$within\$its\$column."

struct Formatter {
mut:
    text  [][]string
    width []int
}

fn new_formatter(text string) Formatter {
    mut f := Formatter{}
    for line in text.split_into_lines() {
        mut words := line.split("\$")
        for words[words.len-1] == "" {
            words = words[..words.len-1]
        }
        f.text << words
        for i, word in words {
            if i == f.width.len {
                f.width << word.len
            } else if word.len > f.width[i] {
                f.width[i] = word.len
            }
        }
    }
    return f
}

enum Justify {
    left = 0
    middle
    right
}

fn (f Formatter) print(j Justify) {
    for line in f.text {
        for i, word in line {
            match j {
                .left {
                    print('$word${' '.repeat(f.width[i]-word.len)} ')
                }
                .middle {
                    mut extra := 0
                    if (f.width[i]%2==1 && word.len%2==0) || (f.width[i]%2==0 && word.len%2==1) {
                        extra++
                    }
                    print('${' '.repeat((f.width[i]-word.len)/2)}$word${' '.repeat((f.width[i]-word.len)/2+extra)} ')
                }
                .right {
                    print('${' '.repeat(f.width[i]-word.len)}$word ')
                }
            }
        }
        println("")
    }
    println("")
}

fn main() {
    f := new_formatter(text)
    f.print(Justify.left)
    f.print(Justify.middle)
    f.print(Justify.right)
}
