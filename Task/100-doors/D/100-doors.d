import std.stdio, std.algorithm, std.range;

enum DoorState : bool { closed, open }
alias Doors = DoorState[];

Doors flipUnoptimized(Doors doors) pure nothrow {
    doors[] = DoorState.closed;

    foreach (immutable i; 0 .. doors.length)
        for (int j = i; j < doors.length; j += i + 1)
            if (doors[j] == DoorState.open)
                doors[j] = DoorState.closed;
            else
                doors[j] = DoorState.open;
    return doors;
}

Doors flipOptimized(Doors doors) pure nothrow {
    doors[] = DoorState.closed;
    for (int i = 1; i ^^ 2 <= doors.length; i++)
        doors[i ^^ 2 - 1] = DoorState.open;
    return doors;
}

void main() {
    auto doors = new Doors(100);

    foreach (const open; [doors.dup.flipUnoptimized,
                          doors.dup.flipOptimized])
        iota(1, open.length + 1).filter!(i => open[i - 1]).writeln;
}
