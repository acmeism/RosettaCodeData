def powerSetRec(head, tail) {
    if (!tail) return [head]
    powerSetRec(head, tail.tail()) + powerSetRec(head + [tail.head()], tail.tail())
}

def powerSet(set) { powerSetRec([], set as List) as Set}
