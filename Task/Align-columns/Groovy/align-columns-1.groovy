def alignColumns = { align, rawText ->
    def lines = rawText.tokenize('\n')
    def words = lines.collect { it.tokenize(/\$/) }
    def maxLineWords = words.collect {it.size()}.max()
    words = words.collect { line -> line + [''] * (maxLineWords - line.size()) }
    def columnWidths = words.transpose().collect{ column -> column.collect { it.size() }.max() }

    def justify = [   Right  : { width, string -> string.padLeft(width) },
                            Left   : { width, string -> string.padRight(width) },
                            Center : { width, string -> string.center(width) }      ]
    def padAll = { pad, colWidths, lineWords -> [colWidths, lineWords].transpose().collect { pad(it) + ' ' } }

    words.each { padAll(justify[align], columnWidths, it).each { print it }; println() }
}
