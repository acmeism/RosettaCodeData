sub mode (*@a) {=
    return |(@a
        .Bag                # count elements
        .classify(*.value)  # group elements with the same count
        .max(*.key)         # get group with the highest count
        .value.map(*.key);  # get elements in the group
    );
}
