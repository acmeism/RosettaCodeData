import "./dynamic" for Struct
import "random" for Random
import "./fmt" for Fmt
import "./ioutil" for Input
import "./str" for Str

var fields = ["name", "age", "bored", "food", "poop"]
var Tamagotchi = Struct.create("Tamagotchi", fields)

var tama  // current Tamagotchi

var rand = Random.new()

var verbs = [
    "Ask", "Ban", "Bash", "Bite", "Break", "Build",
    "Cut", "Dig", "Drag", "Drop", "Drink", "Enjoy",
    "Eat", "End", "Feed", "Fill", "Force", "Grasp",
    "Gas", "Get", "Grab", "Grip", "Hoist", "House",
    "Ice", "Ink", "Join", "Kick", "Leave", "Marry",
    "Mix", "Nab", "Nail", "Open", "Press", "Quash",
    "Rub", "Run", "Save", "Snap", "Taste", "Touch",
    "Use", "Vet", "View", "Wash", "Xerox", "Yield"
]

var nouns = [
    "arms", "bugs", "boots", "bowls", "cabins", "cigars",
    "dogs", "eggs", "fakes", "flags", "greens", "guests",
    "hens", "hogs", "items", "jowls", "jewels", "juices",
    "kits", "logs", "lamps", "lions", "levers", "lemons",
    "maps", "mugs", "names", "nests", "nights", "nurses",
    "orbs", "owls", "pages", "posts", "quests", "quotas",
    "rats", "ribs", "roots", "rules", "salads", "sauces",
    "toys", "urns", "vines", "words", "waters", "zebras"
]

var boredIcons = ["💤", "💭", "❓"]
var foodIcons  = ["🍼", "🍔", "🍟", "🍰", "🍜"]
var poopIcons  = ["💩"]
var sickIcons1 = ["😄", "😃", "😀", "😊", "😎", "👍"] // ok
var sickIcons2 = ["😪", "😥", "😰", "😓"] // ailing
var sickIcons3 = ["😩", "😫"] // bad
var sickIcons4 = ["😡", "😱"] // very bad
var sickIcons5 = ["❌", "💀", "👽", "😇"] // dead

// convert to string and add braces {}
var brace = Fn.new { |chars| "{" + chars.join() + "}" }

var create = Fn.new { |name| tama = Tamagotchi.new(name, 0, 0, 2, 0) }

// too much boredom / food / poop
var sickness = Fn.new {
    // dies at age 42 at the latest
    return tama.poop + tama.bored + 0.max(tama.age-32) + (tama.food-2).abs
}

// alive if sickness <= 10
var alive = Fn.new { sickness.call() <= 10 }

var feed = Fn.new { tama.food = tama.food + 1 }

// may or may not help with boredom
var play = Fn.new { tama.bored = 0.max(tama.bored-rand.int(2)) }

var talk = Fn.new {
    var verb = verbs[rand.int(verbs.count)]
    var noun = nouns[rand.int(nouns.count)]
    System.print("😮 : %(verb) the %(noun).")
    tama.bored = 0.max(tama.bored-1)
}

var clean = Fn.new { tama.poop = 0.max(tama.poop-1) }

// get older / eat food / get bored / poop
var wait = Fn.new {
    tama.age = tama.age + 1
    tama.bored = tama.bored + rand.int(2)
    tama.food = 0.max(tama.food-2)
    tama.poop = tama.poop + rand.int(2)
}

// get boredom / food / poop icons
var status = Fn.new {
    if (alive.call()) {
        var b = []
        var f = []
        var p = []
        for (i in 0...tama.bored) {
            b.add(boredIcons[rand.int(boredIcons.count)])
        }
        for (i in 0...tama.food) {
            f.add(foodIcons[rand.int(foodIcons.count)])
        }
        for (i in 0...tama.poop) {
            p.add(poopIcons[rand.int(poopIcons.count)])
        }
        return Fmt.swrite("$s  $s  $s", brace.call(b), brace.call(f),  brace.call(p))
    }
    return " R.I.P"
}

// get health status from sickness level
var health = Fn.new {
    var s = sickness.call()
    var icon
    if (s == 0 || s == 1 || s == 2) {
        icon = sickIcons1[rand.int(sickIcons1.count)]
    } else if (s == 3 || s == 4) {
        icon = sickIcons2[rand.int(sickIcons2.count)]
    } else if (s == 5 || s == 6) {
        icon = sickIcons3[rand.int(sickIcons3.count)]
    } else if (s == 7 || s == 8 || s ==  9 || s == 10) {
        icon = sickIcons4[rand.int(sickIcons4.count)]
    } else {
        icon = sickIcons5[rand.int(sickIcons5.count)]
    }
    Fmt.print("$s (🎂 $d)  $s $d  $s\n", tama.name, tama.age, icon, s, status.call())
}

var blurb = Fn.new {
    System.print("When the '?' prompt appears, enter an action optionally")
    System.print("followed by the number of repetitions from 1 to 9.")
    System.print("If no repetitions are specified, one will be assumed.")
    System.print("The available options are: feed, play, talk, clean or wait.\n")
}

System.print("         TAMAGOTCHI EMULATOR")
System.print("         ===================\n")
var name = Input.text("Enter the name of your tamagotchi : ", 1)
name = Str.lower(name.trim())
create.call(name)
Fmt.print("\n$*s (age) health {bored} {food}  {poop}\n", -name.count, "name")
health.call()
blurb.call()
var count = 0
while (alive.call()) {
    var input = Str.lower(Input.text("? ", 1).trim())
    var items = input.split(" ").where { |s| s != "" }.toList
    if (items.count > 2) continue
    var action = items[0]
    if (action != "feed" && action != "play" && action != "talk" &&
        action != "clean" && action != "wait") continue
    var reps = 1
    if (items.count == 2) reps = Num.fromString(items[1])
    for (i in 0...reps) {
        if (action == "feed") {
            feed.call()
        } else if (action == "play") {
            play.call()
        } else if (action == "talk") {
            talk.call()
        } else if (action == "clean") {
            clean.call()
        } else if (action == "wait") {
            wait.call()
        }
        // simulate wait on every third (non-wait) action, say
        if (action != "wait") {
            count= count + 1
            if (count%3 == 0) wait.call()
        }
    }
    health.call()
}
