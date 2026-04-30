import rand
import rand.seed
import os

const lower = "abcdefghijklmnopqrstuvwxyz"
const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const digit = "0123456789"
const other = "!\"#$%&()*+,-./:;<=>?@[]^_{|}~"
const excl_chars = [
    "'I', 'l' and '1'",
    "'O' and '0'     ",
    "'5' and 'S'     ",
    "'2' and 'Z'     "
]

fn shuffle(s string) string {
    mut runes := s.runes()
    mut n := runes.len
    for n > 1 {
        k := rand.int_in_range(0, n) or { 0 }
        n--
        runes[n], runes[k] = runes[k], runes[n]
    }
    return runes.string()
}

fn generate_passwords(pwd_len int, pwd_num int, to_console bool, to_file bool) {
    mut lower_str := lower
    mut upper_str := upper
    mut digit_str := digit
    mut other_str := other
	mut sb := []rune{}
	mut pwd :=""
    ll := lower_str.len
    ul := upper_str.len
    dl := digit_str.len
    ol := other_str.len
    tl := ll + ul + dl + ol
    if to_console { println("\nThe generated passwords are:") }
    for i in 0 .. pwd_num {
        sb.clear()
        sb << lower_str[rand.int_in_range(0, ll) or { 0 }]
        sb << upper_str[rand.int_in_range(0, ul) or { 0 }]
        sb << digit_str[rand.int_in_range(0, dl) or { 0 }]
        sb << other_str[rand.int_in_range(0, ol) or { 0 }]
        for _ in 0 .. (pwd_len - 4) {
            k := rand.int_in_range(0, tl) or { 0 }
            if k < ll { sb << lower_str[k] }
			else if k < ll + ul { sb << upper_str[k - ll] }
			else if k < ll + ul + dl { sb << digit_str[k - ll - ul] }
			else { sb << other_str[k - ll - ul - dl] }
        }
        pwd = sb.string()
        for _ in 0 .. 5 {
            pwd = shuffle(pwd)
        }
        if to_console { println("  ${i + 1:2d}:  $pwd") }
        if to_file { println("[FILE] $pwd") }
    }
    if to_file { println("\nThe generated passwords have been printed here instead of written to a file.") }
}

fn print_help() {
    println("
This program generates up to 99 passwords of between 5 and 20 characters in
length.

You will be prompted for the values of all parameters when the program is run
- there are no command line options to memorize.

The passwords can either be written to the console or to a file (pwds.txt),
or both.

The passwords must contain at least one each of the following character types:
   lower-case letters :  a -> z
   upper-case letters :  A -> Z
   digits             :  0 -> 9
   other characters   :  !#$%&()*+,-./:;<=>?@[]^_{|}~\"

Optionally, a seed can be set for the random generator
(any non-zero integer) otherwise the default seed will be used.
Even if the same seed is set, the passwords will not necessarily be exactly
the same on each run as additional random shuffles are always performed.

You can also specify that various sets of visually similar characters
will be excluded (or not) from the passwords, namely: Il1  O0  5S  2Z

Finally, the only command line options permitted are -h and -help which
will display this page and then exit.

Any other command line parameters will simply be ignored and the program
will be run normally.
")
}

fn main() {
	args := os.args[1..]
	seeds := seed.time_seed_array(2)
	rand.seed(seeds)
	mut yn := ""	
    mut lower_str := lower
    mut upper_str := upper
    mut digit_str := digit
	mut pwd_len, mut pwd_num := 0, 0
	mut to_console, mut to_file := false, true	
    if args.len == 1 && (args[0] == "-h" || args[0] == "-help") {
        print_help()
        return
    }
    println("Please enter the following and press return after each one:")
    for {
        print("  Password length (5 to 20)     : ")
        input := os.get_line()
        pwd_len = input.int()
        if pwd_len >= 5 && pwd_len <= 20 { break }
    }
    for {
        print("  Number to generate (1 to 99)  : ")
        input := os.get_line()
        pwd_num = input.int()
        if pwd_num >= 1 && pwd_num <= 99 { break }
    }
    println("  Exclude the following visually similar characters")
    for i, excl in excl_chars {
        yn = ""
        for {
            print("    $excl y/n : ")
            yn = os.get_line().to_lower()
            if yn == "y" || yn == "n" { break }
        }
        if yn == "y" {
            match i {
                0 {
                    upper_str = upper_str.replace("I", "")
                    lower_str = lower_str.replace("l", "")
                    digit_str = digit_str.replace("1", "")
                }
                1 {
                    upper_str = upper_str.replace("O", "")
                    digit_str = digit_str.replace("0", "")
                }
                2 {
                    upper_str = upper_str.replace("S", "")
                    digit_str = digit_str.replace("5", "")
                }
                3 {
                    upper_str = upper_str.replace("Z", "")
                    digit_str = digit_str.replace("2", "")
                }
                else {}
            }
        }
    }
    for {
        print("  Write to console   y/n : ")
        t := os.get_line()
        if t == "y" {
            to_console = true
            break
        }
		else if t == "n" {
            to_console = false
            break
        }
    }
    if to_console {
        for {
            print("  Write to file      y/n : ")
            t := os.get_line()
            if t == "y" {
                to_file = true
                break
            }
			else if t == "n" {
                to_file = false
                break
            }
        }
    }
    generate_passwords(pwd_len, pwd_num, to_console, to_file)
}
