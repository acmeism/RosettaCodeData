sub mode (*@a) {
    return |(@a
        .Bag                # count elements
        .classify(*.value)  # group elements with the same count
        .max(*.key)         # get group with the highest count
        .value.map(*.key);  # get elements in the group
    );
}

say mode [1, 3, 6, 6, 6, 6, 7, 7, 12, 12, 17];
say mode [1, 1, 2, 4, 4];
