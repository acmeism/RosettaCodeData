def arithMean = { list ->
    list == null \
        ? null \
        : list.empty \
            ? 0 \
            : list.sum() / list.size()
}

def geomMean = { list ->
    list == null \
        ? null \
        : list.empty \
            ? 1 \
            : list.inject(1) { prod, item -> prod*item } ** (1 / list.size())
}

def harmMean = { list ->
    list == null \
        ? null \
        : list.empty \
            ? 0 \
            : list.size() / list.collect { 1.0/it }.sum()
}
