function deque(arr) {
    arr["start"] = 0
    arr["end"] = 0
}

function dequelen(arr) {
    return arr["end"] - arr["start"]
}

function empty(arr) {
    return dequelen(arr) == 0
}

function push(arr, elem) {
    arr[++arr["end"]] = elem
}

function pop(arr) {
    if (empty(arr)) {
        return
    }
    return arr[arr["end"]--]
}

function unshift(arr, elem) {
    arr[arr["start"]--] = elem
}

function shift(arr) {
    if (empty(arr)) {
        return
    }
    return arr[++arr["start"]]
}

function printdeque(arr,    i, sep) {
    printf("[")
    for (i = arr["start"] + 1; i <= arr["end"]; i++) {
        printf("%s%s", sep, arr[i])
        sep = ", "
    }
    printf("]\n")
}

BEGIN {
    deque(q)
    for (i = 1; i <= 10; i++) {
        push(q, i)
    }
    printdeque(q)
    for (i = 1; i <= 10; i++) {
        print shift(q)
    }
    printdeque(q)
}
