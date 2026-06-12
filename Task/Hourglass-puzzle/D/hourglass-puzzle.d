import std.stdio, std.algorithm, core.stdc.stdlib, std.typecons;

enum FlipAction { FLIP4, FLIP7, FLIPBOTH }

struct HourglassesState {
    int timeStamp;
    int glass4TimeLeft;
    int glass7TimeLeft;

    void flip(FlipAction flipAction) {
        if (flipAction == FlipAction.FLIP4) {
            glass4TimeLeft = 4 - glass4TimeLeft;
        }
        else if (flipAction == FlipAction.FLIP7) {
            glass7TimeLeft = 7 - glass7TimeLeft;
        }
        else if (flipAction == FlipAction.FLIPBOTH) {
            glass4TimeLeft = 4 - glass4TimeLeft;
            glass7TimeLeft = 7 - glass7TimeLeft;
        }
    }

    void runToNextTimestamp() {
        int deltaT = minElement([glass4TimeLeft, glass7TimeLeft].filter!"a>0");
        timeStamp += deltaT;
        glass4TimeLeft = max(0, glass4TimeLeft - deltaT);
        glass7TimeLeft = max(0, glass7TimeLeft - deltaT);
    }
}

void process(FlipAction flipAction) {
    auto newState = hourglassesStates[$-1];
    newState.flip(flipAction);
    newState.runToNextTimestamp();

    hourglassesStates ~= newState;
    flipSequence ~= flipAction;
}

void undo() {
    hourglassesStates.length--;
    flipSequence.length--;
}

void backtracking() {
    if (hourglassesStates[$-1].timeStamp > target)
        return;

    if (hourglassesStates[$-1].timeStamp == target) {
        showSolution(flipSequence);
        exit(0);
    }

    foreach (flipAction; [FlipAction.FLIP4, FlipAction.FLIP7, FlipAction.FLIPBOTH]) {
        process(flipAction);
        backtracking();
        undo();
    }
}

void showSolution(FlipAction[] flipSequence) {
    writeln("Time    Time left     Time left");
    writeln("        in Glass 4    in Glass 7");

    auto hs = HourglassesState(0, 0, 0);
    writefln("%3d %9d %12d", hs.timeStamp, hs.glass4TimeLeft, hs.glass7TimeLeft);

    auto flipTuple = [tuple("flip", ""), tuple("", "flip"), tuple("flip", "flip")];
    foreach (flipAction; flipSequence) {
        writefln("%15s %12s", flipTuple[flipAction].expand);

        hs.flip(flipAction);
        writefln("%3d %9d %12d", hs.timeStamp, hs.glass4TimeLeft, hs.glass7TimeLeft);

        hs.runToNextTimestamp();
        writefln("%3d %9d %12d", hs.timeStamp, hs.glass4TimeLeft, hs.glass7TimeLeft);
    }
}

auto hourglassesStates = [HourglassesState(0, 0, 0)];
FlipAction[] flipSequence = [];
int target = 9;

void main() {
    backtracking();
}
