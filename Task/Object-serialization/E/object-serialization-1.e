def makeEvent(time :int) {
    return def event {
        to __printOn(out) { out.print(`@@$time`) }
        to __optUncall() { return [makeEvent, "run", [time]] }
        to getTime() { return time }
    }
}

def makeArrival(time :int, what :any, position :int) {
    return def arrival extends makeEvent(time) {
        to __printOn(out) {
            out.print(`$what to $position $super`)
        }
        to __optUncall() {
            return [makeArrival, "run", [time, what, position]]
        }

        to getWhat() { return what }
        to getPosition() { return position }
    }
}
