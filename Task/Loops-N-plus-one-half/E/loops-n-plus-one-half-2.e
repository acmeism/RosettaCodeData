var i := 1
__loop(fn {
    print(i)
    if (i >= 10) {
        false
    } else {
        print(", ")
        i += 1
        true
    }
})
