def isNumeric = {
    def formatter = java.text.NumberFormat.instance
    def pos = [0] as java.text.ParsePosition
    formatter.parse(it, pos)

    // if parse position index has moved to end of string
    // them the whole string was numeric
    pos.index == it.size()
}
