def stripChars = { string, stripChars ->
    def list = string as List
    list.removeAll(stripChars as List)
    list.join()
}
