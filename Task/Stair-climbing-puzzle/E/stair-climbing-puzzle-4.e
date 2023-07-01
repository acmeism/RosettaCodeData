def stepUpEventualRecur() {
    if (!step()) {
        return when (stepUpEventualRecur <- (),
                     stepUpEventualRecur <- ()) -> {}
    }
}
