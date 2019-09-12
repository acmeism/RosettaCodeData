iterator Combinations(m: int, n: int): seq[int] =
    var result = newSeq[int](m)
    var stack = initDeque[int]()
    stack.addLast 0
    while len(stack) > 0:
        var index = len(stack) - 1
        var value = stack.popLast()
        while value < n:
            value = value + 1
            result[index] = value
            index = index + 1
            stack.addLast value

            if index == m:
                yield result
                break
