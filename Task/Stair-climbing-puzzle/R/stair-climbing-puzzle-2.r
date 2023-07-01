stepUp <- function() {
    while(! step()) {
        stepUp()
    }
}
