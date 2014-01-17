def wordWrap(text, length = 80) {
    def sb = new StringBuilder()
    def line = ''

    text.split(/\s/).each { word ->
        if (line.size() + word.size() > length) {
            sb.append(line.trim()).append('\n')
            line = ''
        }
        line += " $word"
    }
    sb.append(line.trim()).toString()
}
