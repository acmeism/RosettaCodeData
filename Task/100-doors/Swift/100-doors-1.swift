/* declare enum to identify the state of a door */
enum DoorState : String {
    case Opened = "Opened"
    case Closed = "Closed"
}

/* declare list of doors state and initialize them */
var doorsStateList = [DoorState](count: 100, repeatedValue: DoorState.Closed)

/* do the 100 passes */
for i in 1...100 {
    /* map on a strideTo instance to only visit the needed doors on each iteration */
    map(stride(from: i - 1, to: 100, by: i)) {
        doorsStateList[$0] = doorsStateList[$0] == .Opened ? .Closed : .Opened
    }
}

/* print the results */
for (index, item) in enumerate(doorsStateList) {
    println("Door \(index+1) is \(item.rawValue)")
}
