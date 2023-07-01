shared void run() {
    print("Open doors (naive):     ``naive()``
           Open doors (optimized): ``optimized()``");

}

shared {Integer*} naive(Integer count = 100) {
    variable value doors = [ for (_ in 1..count) closed ];
    for (step in 1..count) {
        doors = [for (i->door in doors.indexed) let (index = i+1) if (step == 1 || step.divides(index)) then door.toggle() else door ];
    }
    return doors.indexesWhere((door) => door == opened).map(1.plusInteger);
}

shared {Integer*} optimized(Integer count = 100) =>
        { for (i in 1..count) i*i }.takeWhile(count.notSmallerThan);


shared abstract class Door(shared actual String string) of opened | closed {
    shared formal Door toggle();
}
object opened extends Door("opened") { toggle() => closed; }
object closed extends Door("closed") { toggle() => opened; }
