import os
import strconv
import rand
import rand.seed

struct Tamagotchi {
    name string
mut:
    age int
bored int
food int
poop int
}

const (
verbs = [
"Ask", "Ban", "Bash", "Bite", "Break", "Build",
"Cut", "Dig", "Drag", "Drop", "Drink", "Enjoy",
"Eat", "End", "Feed", "Fill", "Force", "Grasp",
"Gas", "Get", "Grab", "Grip", "Hoist", "House",
"Ice", "Ink", "Join", "Kick", "Leave", "Marry",
"Mix", "Nab", "Nail", "Open", "Press", "Quash",
"Rub", "Run", "Save", "Snap", "Taste", "Touch",
"Use", "Vet", "View", "Wash", "Xerox", "Yield",
]

nouns = [
"arms", "bugs", "boots", "bowls", "cabins", "cigars",
"dogs", "eggs", "fakes", "flags", "greens", "guests",
"hens", "hogs", "items", "jowls", "jewels", "juices",
"kits", "logs", "lamps", "lions", "levers", "lemons",
"maps", "mugs", "names", "nests", "nights", "nurses",
"orbs", "owls", "pages", "posts", "quests", "quotas",
"rats", "ribs", "roots", "rules", "salads", "sauces",
"toys", "urns", "vines", "words", "waters", "zebras",
]

    bored_icons = [`💤`, `💭`, `❓`]
    food_icons  = [`🍼`, `🍔`, `🍟`, `🍰`, `🍜`]
    poop_icons  = [`💩`]
    sick__icons1 = [`😄`, `😃`, `😀`, `😊`, `😎`, `👍`] // ok
    sick__icons2 = [`😪`, `😥`, `😰`, `😓`] // ailing
    sick__icons3 = [`😩`, `😫`] // bad
    sick__icons4 = [`😡`, `😱`] // very bad
    sick__icons5 = [`❌`, `💀`, `👽`, `😇`] // dead
)

fn max(x int, y int) int {
    if x > y {
        return x
    }
    return y
}

fn abs(a int) int {
    if a < 0 {
        return -a
    }
    return a
}

// convert to string and add braces {}
fn brace(runes []rune) string {
    return '{ ${runes.string()} }'
}

fn create(name string) Tamagotchi {
    return Tamagotchi{name, 0, 0, 2, 0}
}

// alive if sickness <= 10
fn (tama Tamagotchi) alive() bool {
    if tama.sickness() <= 10 {
        return true
    }
    return false
}

fn (mut tama Tamagotchi) feed() {
    tama.food++
}

// may or may not help with boredom
fn (mut tama Tamagotchi) play() {
    tama.bored = max(0, tama.bored-rand.intn(2) or {1})
}

fn (mut tama Tamagotchi) talk() {
    verb := verbs[rand.intn(verbs.len) or {0}]
    noun := nouns[rand.intn(nouns.len) or {0}]
    println("😮 : $verb the ${noun}.")
    tama.bored = max(0, tama.bored-1)
}

fn (mut tama Tamagotchi) clean() {
    tama.poop = max(0, tama.poop-1)
}

// get older / eat food / get bored / poop
fn (mut tama Tamagotchi) wait() {
    tama.age++
    tama.bored += rand.intn(2) or {1}
    tama.food = max(0, tama.food-2)
    tama.poop += rand.intn(2) or {1}
}

// get boredom / food / poop _icons
fn (tama Tamagotchi) status() string {
    if tama.alive() {
        mut b := []rune{}
mut f := []rune{}
mut p := []rune{}
        for i := 0; i < tama.bored; i++ {
            b << bored_icons[rand.intn(bored_icons.len) or {0}]
        }
        for i := 0; i < tama.food; i++ {
            f << food_icons[rand.intn(food_icons.len) or {0}]
        }
        for i := 0; i < tama.poop; i++ {
            p << poop_icons[rand.intn(poop_icons.len) or {0}]
        }
        return "${brace(b)}  ${brace(f)}  ${brace(p)}"
    }
    return " R.I.P"
}

// too much boredom / food / poop
fn (tama Tamagotchi) sickness() int {
    // dies at age 42 at the latest
    return tama.poop + tama.bored + max(0, tama.age-32) + abs(tama.food-2)
}

// get health status from sickness level
fn (tama Tamagotchi) health() {
    s := tama.sickness()
    mut icon := `a`
    if s in [0,1,2]{
        icon = sick__icons1[rand.intn(sick__icons1.len) or {0}]
} else if s in [3,4] {
        icon = sick__icons2[rand.intn(sick__icons2.len) or {0}]
} else if s in [5, 6] {
        icon = sick__icons3[rand.intn(sick__icons3.len) or {0}]
} else if s in [7, 8, 9, 10] {
        icon = sick__icons4[rand.intn(sick__icons4.len) or {0}]
} else {
        icon = sick__icons5[rand.intn(sick__icons5.len) or {0}]
    }
    println("$tama.name (🎂 $tama.age)  $icon $s  ${tama.status()}\n")
}

fn blurb() {
    println("When the '?' prompt appears, enter an action optionally")
    println("followed by the number of repetitions from 1 to 9.")
    println("If no repetitions are specified, one will be assumed.")
    println("The available options are: feed, play, talk, clean or wait.\n")
}

fn main() {
    rand.seed(seed.time_seed_array(2))
    println("         TAMAGOTCHI EMULATOR")
    println("         ===================\n")
    name := os.input("Enter the name of your tamagotchi : ")
    mut tama := create(name)
    println("\nname (age) health {bored} {food}  {poop}\n")
    tama.health()
    blurb()
    mut count := 0
    for tama.alive() {
        input := os.input("? ")
        items := input.split(" ")
        if items.len > 2 {
            continue
        }
        action := items[0]
        if action != "feed" && action != "play" && action != "talk" &&
            action != "clean" && action != "wait" {
            continue
        }
        mut reps := 1
        if items.len == 2 {
            //var err error
            reps = strconv.atoi(items[1]) or {break}
        }
        for _ in 0..reps {
            match action {
                "feed" {
                    tama.feed()
                }
                "play" {
                    tama.play()
                }
                "talk" {
                    tama.talk()
                }
               "clean" {
                   tama.clean()
                }
                else {
                   tama.wait()
                }
            }
            // simulate wait on every third (non-wait) action, say
            if action != "wait" {
                count++
                if count%3 == 0 {
                    tama.wait()
                }
            }
        }
        tama.health()
    }
}
