package main

import (
    "flag"
    "fmt"
    "log"
    "math/rand"
    "regexp"
    "strings"
    "time"

    "github.com/BurntSushi/toml"
)

var help = `rps plays rock-paper-scissors with optional addition weapons.

Usage: rps [-h] [game]
   -h   display help.
   game is a game description file in TOML (https://github.com/mojombo/toml).

The traditional game can be described as

title = "Rock Paper Scissors"
win = [
   "rock breaks scissors",
   "paper covers rock",
   "scissors cut paper",
]

The title is optional, it just prints out at the beginning of a game.

The "win" list is statments where the first word wins over the last word.

It's case sensitive so make things easy by using consistent case.
Don't use punctuation, at least not next to a first or last word.

Additionally, you can have a "lose" key where the first word loses to the
the last, for example

lose = ["rock falls into well"]

To organize things with additional weapons, you can just use the winning
weapon with a list of clauses, for example

lizard = ["poisons Spock", "eats paper"]

The progam ignores anything in parentheses when identifying first or last
words.  Examples (from RPS-101) with weapons gun, fire, and sword,

win = [
   "gun fire(s)"
   "(flaming) sword has fire"
]

Finally, TOML is a hash, so don't duplicate keys.  That means no multiple
win or lose keys.  You must combine all the win statements and all the lose
statements.`

var rps = `
title = "Rock Paper Scissors"
win = [
    "rock breaks scissors",
    "paper covers rock",
    "scissors cut paper",
]`

func main() {
    h := flag.Bool("h", false, "show help")
    flag.Parse()
    if *h {
        fmt.Println(help)
        return
    }
    m := map[string]interface{}{}
    var err error
    switch flag.NArg() {
    case 0:
        _, err = toml.Decode(rps, &m)
    case 1:
        _, err = toml.DecodeFile(flag.Arg(0), &m)
    default:
        flag.Usage()
        return
    }
    if err != nil {
        log.Fatal(err)
    }
    play(parse(m))
}

type decision map[string]map[string]string

type fIndex map[string]int

func parse(m map[string]interface{}) (title string, f fIndex, d decision) {
    d = decision{}
    for k, v := range m {
        switch t := v.(type) {
        case []interface{}:
            d.parseList(k, t)
        case string:
            if k == "title" {
                title = t
            } else {
                log.Println("Unknown key:", k)
            }
        }
    }
    i := 0
    f = fIndex{}
    for w, wl := range d {
        if _, ok := f[w]; !ok {
            f[w] = i
            i++
        }
        for l := range wl {
            if _, ok := f[l]; !ok {
                f[l] = i
                i++
            }
        }
    }
    for fm := range f {
        if _, ok := d[fm]; !ok {
            log.Println("note,", fm, "always loses!")
        }
    }
    balanced := len(f)&1 == 1
    for _, l := range d {
        if !balanced {
            break
        }
        balanced = len(l)*2+1 == len(f)
    }
    if !balanced {
        log.Print("note, game is unbalanced")
    }
    return title, f, d
}

var r = regexp.MustCompile(`[(].*[)]`)

func (d decision) parseList(kw string, l []interface{}) {
    var ww string
    for _, e := range l {
        st, ok := e.(string)
        if !ok {
            log.Fatal("invalid", e)
        }
        w := strings.Fields(r.ReplaceAllLiteralString(st, ""))
        if len(w) == 0 {
            log.Fatalln("invalid:", kw, st)
        }
        lw := w[len(w)-1]
        switch kw {
        case "win":
            ww = w[0]
        case "lose":
            ww, lw = lw, w[0]
        default:
            ww = kw
            for i := 0; ; i++ {
                if i == len(w) {
                    st = ww + " " + st
                    break
                }
                if w[i] == ww {
                    break
                }
            }
        }
        if lw == ww {
            log.Fatalln("invalid:", st)
        }
        if cs, ok := d[lw][ww]; ok {
            log.Fatalln("conflict:", cs, "and", st)
        }
        d1, ok := d[ww]
        if !ok {
            d1 = map[string]string{}
        }
        d1[lw] = st
        d[ww] = d1
    }
}

func play(title string, fx fIndex, d decision) {
    rand.Seed(time.Now().Unix())
    if len(fx) == 0 {
        return
    }
    form := make([]string, len(fx))
    for w, i := range fx {
        form[i] = w
    }
    fmt.Println()
    fmt.Println(title)
    fmt.Print("Choices are ", form[0])
    for _, w := range form[1:] {
        fmt.Printf(", %s", w)
    }
    fmt.Println(".")
    fmt.Println("Enter one of these choices as your play.  " +
        "Anything else ends the game.")
    fmt.Println("Running score shown as <your wins>:<my wins>")
    var pw string
    var aScore, pScore int
    sl := 3
    wcf := make([]int, len(form))
    wct := 0
    ax := rand.Intn(len(form))
    aw := form[ax]
    for {
        fmt.Print("Play: ")
        _, err := fmt.Scanln(&pw)
        if err != nil {
            break
        }
        px, ok := fx[pw]
        if !ok {
            fmt.Println(pw, "invalid.")
            break
        }
        for f, l := range d {
            if _, ok := l[pw]; ok {
                wcf[fx[f]]++
                wct++
            }
        }

        fmt.Printf("My play:%s%s.\n", strings.Repeat(" ", sl-2), aw)
        ast := d[aw][pw]
        pst := d[pw][aw]
        switch {
        case ax == px:
            fmt.Println("Tie.")
        case ast > "" && pst > "":
            log.Fatalln("conflict: ", ast, "and", pst)
        case ast > "":
            fmt.Printf("%s.  My point.\n", ast)
            aScore++
        default:
            fmt.Printf("%s.  Your point.\n", pst)
            pScore++
        }
        sl, _ = fmt.Printf("%d:%d  ", pScore, aScore)
        ax = 0
        for rn := rand.Intn(wct); ; ax++ {
            if f := wcf[ax]; rn < f {
                break
            } else {
                rn -= f
            }
        }
        aw = form[ax]
    }
}
