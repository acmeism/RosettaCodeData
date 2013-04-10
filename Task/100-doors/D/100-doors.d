import std.stdio;

enum DoorState { Closed, Open }
alias DoorState[] Doors;

Doors flipUnoptimized(Doors doors) {
    doors[] = DoorState.Closed;
    foreach (i; 0 .. doors.length)
        for (int j = i; j < doors.length; j += i+1)
            if (doors[j] == DoorState.Open)
                doors[j] = DoorState.Closed;
            else
                doors[j] = DoorState.Open;
    return doors;
}

Doors flipOptimized(Doors doors) {
    doors[] = DoorState.Closed;
    for (int i = 1; i*i <= doors.length; i++)
        doors[i*i - 1] = DoorState.Open;
    return doors;
}

// test program
void main() {
    auto doors = new Doors(100);
    foreach (i, door; flipUnoptimized(doors))
        if (door == DoorState.Open)
            write(i+1, " ");
    writeln();

    foreach (i, door; flipOptimized(doors))
        if (door == DoorState.Open)
            write(i+1, " ");
    writeln();
}
