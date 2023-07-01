def makeMutex() {

    # The mutex is available (released) if available is resolved, otherwise it
    # has been seized/locked. The specific value of available is irrelevant.
    var available := null

    # The interface to the mutex is a function, taking a function (action)
    # to be executed.
    def mutex(action) {
        # By assigning available to our promise here, the mutex remains
        # unavailable to the /next/ caller until /this/ action has gotten
        # its turn /and/ resolved its returned value.
        available := Ref.whenResolved(available, fn _ { action <- () })
    }
    return mutex
}
