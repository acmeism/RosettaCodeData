def makeColor(name :String) {
    def color {
        to colorize(thing :String) {
          return `$name $thing`
        }
    }
    return color
}
