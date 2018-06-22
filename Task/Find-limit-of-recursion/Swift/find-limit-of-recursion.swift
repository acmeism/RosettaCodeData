var n = 1

func recurse() {
    print(n)
    n += 1
    recurse()
}

recurse()
