def stepUpRecur() {
    if (!step()) {
        stepUpRecur()
        stepUpRecur()
    }
}
