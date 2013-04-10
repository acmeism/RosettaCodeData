def makeEvent() {
    def [var fired, var firer] := Ref.promise()

    def event {
        to signal() {
            firer.resolveRace(null) # all current and future wait()s will resolve
        }
        to reset() {
            if (firer.isDone()) { # ignore multiple resets. If we didn't, then
                                  # reset() wait() reset() signal() would never
                                  # resolve that wait().
                # create all fresh state
                def [p, r] := Ref.promise()
                fired := p
                firer := r
            }
        }
        to wait() {
            return fired
        }
    }

    return event
}
