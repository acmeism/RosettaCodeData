String wordWrap(str, width=80) {
  str.tokenize(' ').inject([[]]) { rows, word ->
    if (rows.last().join(' ').length() + word.length() <= width) rows.last() << word else rows << [word]
    rows
  }.collect { it.join(' ') }.join('\n')
}
