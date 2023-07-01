func three() *int {
    i := 3
    return &i // valid.  no worry, no crash.
}
