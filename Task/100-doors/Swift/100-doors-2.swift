/* declare enum to identify the state of a door */
enum DoorState : String {
    case Opened = "Opened"
    case Closed = "Closed"
}

/* declare list of doors state and initialize them */
var doorsStateList = [DoorState](count: 100, repeatedValue: DoorState.Closed)

/* set i^2 doors to opened */
var i = 1
do {
    doorsStateList[(i*i)-1] = DoorState.Opened
    ++i
} while (i*i) <= doorsStateList.count

/* print the results */
for (index, item) in enumerate(doorsStateList) {
    println("Door \(index+1) is \(item.rawValue)")
}
