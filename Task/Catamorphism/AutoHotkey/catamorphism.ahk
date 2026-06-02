#Requires AutoHotkey v2.0

reduce(arr, fn, seed?) {
    offset := 0
    if !IsSet(seed) {
        if arr.Length = 0
            throw Error("Can't reduce empty array without a seed.", -1)
        seed := arr[1]
        offset++
    }

    loop arr.Length - offset
        seed := fn(seed, arr[A_Index + offset])

    return seed
}

MsgBox reduce([], (x, y) => x + y, 0)
MsgBox reduce([1, 2, 3, 4], (x, y) => x + y)
