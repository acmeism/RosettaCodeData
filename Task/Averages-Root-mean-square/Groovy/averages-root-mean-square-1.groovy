def quadMean = { list ->
    list == null \
        ? null \
        : list.empty \
            ? 0 \
            : ((list.collect { it*it }.sum()) / list.size()) ** 0.5
}
