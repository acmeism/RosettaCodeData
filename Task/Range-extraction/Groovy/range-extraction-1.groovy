def range = { s, e -> s == e ? "${s}," : s == e - 1 ? "${s},${e}," : "${s}-${e}," }

def compressList = { list ->
    def sb, start, end
    (sb, start, end) = [''<<'', list[0], list[0]]
    for (i in list[1..-1]) {
        (sb, start, end) = i == end + 1 ? [sb, start, i] : [sb << range(start, end), i, i]
    }
    (sb << range(start, end))[0..-2].toString()
}

def compressRanges = { expanded -> compressList(Eval.me('[' + expanded + ']')) }
