def flatten(nested) {
    def flat := [].diverge()
    def recur(x) {
        switch (x) {
            match list :List { for elem in list { recur(elem) } }
            match other      { flat.push(other) }
        }
    }
    recur(nested)
    return flat.snapshot()
}
