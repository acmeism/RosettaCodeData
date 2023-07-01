double median(List<Double> values) {
    /* copy, as to prevent modifying 'values' */
    List<Double> list = new ArrayList<>(values);
    Collections.sort(list);
    /* 'mid' will be truncated */
    int mid = list.size() / 2;
    return switch (list.size() % 2) {
        case 0 -> {
            double valueA = list.get(mid);
            double valueB = list.get(mid + 1);
            yield (valueA + valueB) / 2;
        }
        case 1 -> list.get(mid);
        default -> 0;
    };
}
