package main

import (
    "bufio"
    "fmt"
    "log"
    "math/rand"
    "os"
    "strconv"
    "strings"
    "time"
)

type tamagotchi struct {
    name                   string
    age, bored, food, poop int
}

var tama tamagotchi // current tamagotchi

var verbs = []string{
    "Ask", "Ban", "Bash", "Bite", "Break", "Build",
    "Cut", "Dig", "Drag", "Drop", "Drink", "Enjoy",
    "Eat", "End", "Feed", "Fill", "Force", "Grasp",
    "Gas", "Get", "Grab", "Grip", "Hoist", "House",
    "Ice", "Ink", "Join", "Kick", "Leave", "Marry",
    "Mix", "Nab", "Nail", "Open", "Press", "Quash",
    "Rub", "Run", "Save", "Snap", "Taste", "Touch",
    "Use", "Vet", "View", "Wash", "Xerox", "Yield",
}

var nouns = []string{
    "arms", "bugs", "boots", "bowls", "cabins", "cigars",
    "dogs", "eggs", "fakes", "flags", "greens", "guests",
    "hens", "hogs", "items", "jowls", "jewels", "juices",
    "kits", "logs", "lamps", "lions", "levers", "lemons",
    "maps", "mugs", "names", "nests", "nights", "nurses",
    "orbs", "owls", "pages", "posts", "quests", "quotas",
    "rats", "ribs", "roots", "rules", "salads", "sauces",
    "toys", "urns", "vines", "words", "waters", "zebras",
}

var (
    boredIcons = []rune{'💤', '💭', '❓'}
    foodIcons  = []rune{'🍼', '🍔', '🍟', '🍰', '🍜'}
    poopIcons  = []rune{'💩'}
    sickIcons1 = []rune{'😄', '😃', '😀', '😊', '😎', '👍'} // ok
    sickIcons2 = []rune{'😪', '😥', '😰', '😓'} // ailing
    sickIcons3 = []rune{'😩', '😫'} // bad
    sickIcons4 = []rune{'😡', '😱'} // very bad
    sickIcons5 = []rune{'❌', '💀', '👽', '😇'} // dead
)

func max(x, y int) int {
    if x > y {
        return x
    }
    return y
}

func abs(a int) int {
    if a < 0 {
        return -a
    }
    return a
}

// convert to string and add braces {}
func brace(runes []rune) string {
    return fmt.Sprintf("{ %s }", string(runes))
}

func create(name string) {
    tama = tamagotchi{name, 0, 0, 2, 0}
}

// alive if sickness <= 10
func alive() bool {
    if sickness() <= 10 {
        return true
    }
    return false
}

func feed() {
    tama.food++
}

// may or may not help with boredom
func play() {
    tama.bored = max(0, tama.bored-rand.Intn(2))
}

func talk() {
    verb := verbs[rand.Intn(len(verbs))]
    noun := nouns[rand.Intn(len(nouns))]
    fmt.Printf("😮 : %s the %s.\n", verb, noun)
    tama.bored = max(0, tama.bored-1)
}

func clean() {
    tama.poop = max(0, tama.poop-1)
}

// get older / eat food / get bored / poop
func wait() {
    tama.age++
    tama.bored += rand.Intn(2)
    tama.food = max(0, tama.food-2)
    tama.poop += rand.Intn(2)
}

// get boredom / food / poop icons
func status() string {
    if alive() {
        var b, f, p []rune
        for i := 0; i < tama.bored; i++ {
            b = append(b, boredIcons[rand.Intn(len(boredIcons))])
        }
        for i := 0; i < tama.food; i++ {
            f = append(f, foodIcons[rand.Intn(len(foodIcons))])
        }
        for i := 0; i < tama.poop; i++ {
            p = append(p, poopIcons[rand.Intn(len(poopIcons))])
        }
        return fmt.Sprintf("%s  %s  %s", brace(b), brace(f), brace(p))
    }
    return " R.I.P"
}

// too much boredom / food / poop
func sickness() int {
    // dies at age 42 at the latest
    return tama.poop + tama.bored + max(0, tama.age-32) + abs(tama.food-2)
}

// get health status from sickness level
func health() {
    s := sickness()
    var icon rune
    switch s {
    case 0, 1, 2:
        icon = sickIcons1[rand.Intn(len(sickIcons1))]
    case 3, 4:
        icon = sickIcons2[rand.Intn(len(sickIcons2))]
    case 5, 6:
        icon = sickIcons3[rand.Intn(len(sickIcons3))]
    case 7, 8, 9, 10:
        icon = sickIcons4[rand.Intn(len(sickIcons4))]
    default:
        icon = sickIcons5[rand.Intn(len(sickIcons5))]
    }
    fmt.Printf("%s (🎂 %d)  %c %d  %s\n\n", tama.name, tama.age, icon, s, status())
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func blurb() {
    fmt.Println("When the '?' prompt appears, enter an action optionally")
    fmt.Println("followed by the number of repetitions from 1 to 9.")
    fmt.Println("If no repetitions are specified, one will be assumed.")
    fmt.Println("The available options are: feed, play, talk, clean or wait.\n")
}

func main() {
    rand.Seed(time.Now().UnixNano())
    fmt.Println("         TAMAGOTCHI EMULATOR")
    fmt.Println("         ===================\n")
    scanner := bufio.NewScanner(os.Stdin)
    fmt.Print("Enter the name of your tamagotchi : ")
    if ok := scanner.Scan(); !ok {
        check(scanner.Err())
    }
    name := strings.TrimSpace(strings.ToLower(scanner.Text()))
    create(name)
    fmt.Printf("\n%*s (age) health {bored} {food}  {poop}\n\n", -len(name), "name")
    health()
    blurb()
    count := 0
    for alive() {
        fmt.Print("? ")
        if ok := scanner.Scan(); !ok {
            check(scanner.Err())
        }
        input := strings.TrimSpace(strings.ToLower(scanner.Text()))
        items := strings.Split(input, " ")
        if len(items) > 2 {
            continue
        }
        action := items[0]
        if action != "feed" && action != "play" && action != "talk" &&
            action != "clean" && action != "wait" {
            continue
        }
        reps := 1
        if len(items) == 2 {
            var err error
            reps, err = strconv.Atoi(items[1])
            if err != nil {
                continue
            }
        }
        for i := 0; i < reps; i++ {
            switch action {
            case "feed":
                feed()
            case "play":
                play()
            case "talk":
                talk()
            case "clean":
                clean()
            case "wait":
                wait()
            }
            // simulate wait on every third (non-wait) action, say
            if action != "wait" {
                count++
                if count%3 == 0 {
                    wait()
                }
            }
        }
        health()
    }
}
