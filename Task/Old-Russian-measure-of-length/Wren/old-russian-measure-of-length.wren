import "io" for Stdin, Stdout
import "./fmt" for Fmt
import "./str" for Str

var units = [
    "tochka", "liniya", "dyuim", "vershok", "piad", "fut",
    "arshin", "sazhen", "versta", "milia",
    "centimeter", "meter", "kilometer"
]

var convs = [
    0.0254, 0.254, 2.54, 4.445, 17.78, 30.48,
    71.12, 213.36, 10668, 74676,
    1, 100, 10000
]

while (true) {
    var i = 0
    for (u in units) {
        Fmt.print("$2d $s", i+1, u)
        i = i + 1
    }
    System.print()
    var unit
    while (true) {
        System.write("Please choose a unit 1 to 13   : ")
        Stdout.flush()
        unit = Num.fromString(Stdin.readLine())
        if (unit.type == Num && unit.isInteger && unit >= 1 && unit <= 13) break
    }
    unit = unit - 1
    var value
    while (true) {
        System.write("Now enter a value in that unit : ")
        Stdout.flush()
        value = Num.fromString(Stdin.readLine())
        if (value.type == Num && value >= 0) break
    }
    System.print("\nThe equivalent in the remaining units is:\n")
    i = 0
    for (u in units) {
        if (i != unit) Fmt.print(" $10s : $15.8g", u, value*convs[unit]/convs[i])
        i = i + 1
    }
    System.print()
    var yn = ""
    while (yn != "y" && yn != "n") {
        System.write("Do another one y/n : ")
        Stdout.flush()
        yn = Str.lower(Stdin.readLine())
    }
    if (yn == "n") break
    System.print()
}
