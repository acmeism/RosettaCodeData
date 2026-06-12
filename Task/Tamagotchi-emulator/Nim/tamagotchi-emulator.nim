import random, strutils

const

  Verbs = ["Ask", "Ban", "Bash", "Bite", "Break", "Build",
           "Cut", "Dig", "Drag", "Drop", "Drink", "Enjoy",
           "Eat", "End", "Feed", "Fill", "Force", "Grasp",
           "Gas", "Get", "Grab", "Grip", "Hoist", "House",
           "Ice", "Ink", "Join", "Kick", "Leave", "Marry",
           "Mix", "Nab", "Nail", "Open", "Press", "Quash",
           "Rub", "Run", "Save", "Snap", "Taste", "Touch",
           "Use", "Vet", "View", "Wash", "Xerox", "Yield"]

  Nouns = ["arms", "bugs", "boots", "bowls", "cabins", "cigars",
           "dogs", "eggs", "fakes", "flags", "greens", "guests",
           "hens", "hogs", "items", "jowls", "jewels", "juices",
           "kits", "logs", "lamps", "lions", "levers", "lemons",
           "maps", "mugs", "names", "nests", "nights", "nurses",
           "orbs", "owls", "pages", "posts", "quests", "quotas",
           "rats", "ribs", "roots", "rules", "salads", "sauces",
           "toys", "urns", "vines", "words", "waters", "zebras"]

  BoredIcons = ["💤", "💭", "❓"]
  FoodIcons  = ["🍼", "🍔", "🍟", "🍰", "🍜"]
  PoopIcons  = ["💩"]
  SickIcons1 = ["😄", "😃", "😀", "😊", "😎", "👍"]   # ok
  SickIcons2 = ["😪", "😥", "😰", "😓"]               # ailing
  SickIcons3 = ["😩", "😫"]                           # bad
  SickIcons4 = ["😡", "😱"]                           # very bad
  SickIcons5 = ["❌", "💀", "👽", "😇"]               # dead


type

  Tamagotchi = object
    name: string
    age, bored, food, poop: int

  Action {.pure.} = enum Feed = "feed", Play = "play", Talk = "talk", Clean = "clean", Wait = "wait"


func initTamagotchi(name: string): Tamagotchi =
  Tamagotchi(name: name, age: 0, bored: 0, food: 2, poop: 0)


func withBraces(s: string): string = "{ $# }" % s


proc feed(t: var Tamagotchi) =
  inc t.food


proc play(t: var Tamagotchi) =
  t.bored = max(0, t.bored - rand(1))


proc talk(t: var Tamagotchi) =
  let verb = Verbs.sample()
  let noun = Nouns.sample()
  echo "😮: $1 the $2.".format(verb, noun)
  t.bored = max(0, t.bored - 1)


proc clean(t: var Tamagotchi) =
  t.poop = max(0, t.poop - 1)


proc wait(t: var Tamagotchi) =
  inc t.age
  t.bored += rand(1)
  t.food = max(0, t.food - 2)
  t.poop += rand(1)


func sickness(t: Tamagotchi): Natural =
  t.poop + t.bored + max(0, t.age - 32) + abs(t.food - 2)


func isAlive(t: Tamagotchi): bool = t.sickness() <= 10


proc status(t: Tamagotchi): string =
  if t.isAlive:
    var b, f, p: string
    for _ in 1..t.bored: b.add BoredIcons.sample()
    for _ in 1..t.food: f.add FoodIcons.sample()
    for _ in 1..t.poop: p.add PoopIcons.sample()
    result = "$1  $2  $3".format(b.withBraces, f.withBraces, p.withBraces)


proc displayHealth(t: Tamagotchi) =
  let s = t.sickness()
  let icon = case s
             of 0, 1, 2: SickIcons1.sample()
             of 3, 4: SickIcons2.sample()
             of 5, 6: SickIcons3.sample()
             of 7, 8, 9, 10: SickIcons4.sample()
             else: SickIcons5.sample()
  echo "$1 (🎂 $2)  $3 $4  $5\n".format(t.name, t.age, icon, s, t.status())


proc blurb() =
  echo "When the '?' prompt appears, enter an action optionally"
  echo "followed by the number of repetitions from 1 to 9."
  echo "If no repetitions are specified, one will be assumed."
  echo "The available options are: feed, play, talk, clean or wait.\n"


randomize()
echo "         TAMAGOTCHI EMULATOR"
echo "         ===================\n"

stdout.write "Enter the name of your tamagotchi: "
stdout.flushFile()
var name = ""
while name.len == 0:
  try:
    name = stdin.readLine.strip()
  except EOFError:
    echo()
    quit "Encountered EOF. Quitting.", QuitFailure
var tama = initTamagotchi(name)
echo "\n$# (age) health {bored} {food}  {poop}\n" % "name".alignLeft(name.len)
tama.displayHealth()
blurb()

var count = 0
while tama.isAlive:
  stdout.write "? "
  stdout.flushFile()
  let input = try: stdin.readLine().strip().toLowerAscii()
              except EOFError:
                echo()
                quit "EOF encountered. Quitting.", QuitFailure
  let items = input.splitWhitespace()
  if items.len notin 1..2: continue
  let action = try: parseEnum[Action](items[0])
               except ValueError: continue
  let reps = if items.len == 2:
               try: items[1].parseInt()
               except ValueError: continue
             else: 1

  for _ in 1..reps:
    case action
    of Feed: tama.feed()
    of Play: tama.play()
    of Talk: tama.talk()
    of Clean: tama.clean()
    of Wait: tama.wait()

    # Simulate wait on every third (non-wait) action.
    if action != Wait:
      inc count
      if count mod 3 == 0:
        tama.wait()

  tama.displayHealth()
