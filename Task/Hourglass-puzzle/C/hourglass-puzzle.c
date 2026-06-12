#include <stdio.h>
#include <stdlib.h>

enum { FLIP4, FLIP7, FLIPBOTH };

struct HourglassesState {
    int timeStamp;
    int glass4TimeLeft;
    int glass7TimeLeft;
};

struct HourglassesState hs;
int stateIdx;
struct HourglassesState hourglassesStates[100];
int flipSequence[50];
const int target = 9;

void flip(struct HourglassesState* hs, int flipAction) {
    if (flipAction == FLIP4) {
        hs->glass4TimeLeft = 4 - hs->glass4TimeLeft;
    }
    else if (flipAction == FLIP7) {
        hs->glass7TimeLeft = 7 - hs->glass7TimeLeft;
    }
    else if (flipAction == FLIPBOTH) {
        hs->glass4TimeLeft = 4 - hs->glass4TimeLeft;
        hs->glass7TimeLeft = 7 - hs->glass7TimeLeft;
    }
}

void runToNextTimestamp(struct HourglassesState* hs) {
    int deltaT;

    if (hs->glass4TimeLeft == 0) {
        hs->timeStamp += hs->glass7TimeLeft;
        hs->glass4TimeLeft = 0;
        hs->glass7TimeLeft = 0;
    }
    else if (hs->glass7TimeLeft == 0) {
        hs->timeStamp += hs->glass4TimeLeft;
        hs->glass4TimeLeft = 0;
        hs->glass7TimeLeft = 0;
    }
    else {
        deltaT = (hs->glass4TimeLeft < hs->glass7TimeLeft) ?
                 hs->glass4TimeLeft : hs->glass7TimeLeft;
        hs->timeStamp += deltaT;
        hs->glass4TimeLeft -= deltaT;
        hs->glass7TimeLeft -= deltaT;
    }
}

void process(int flipAction) {
    struct HourglassesState newState = hourglassesStates[stateIdx - 1];
    flip(&newState, flipAction);
    runToNextTimestamp(&newState);

    hourglassesStates[stateIdx] = newState;
    flipSequence[stateIdx] = flipAction;
    stateIdx++;
}

void undo() {
    stateIdx--;
}

void showSolution() {
    int i;
    struct HourglassesState hs = { 0, 0, 0 };

    printf("Time    Time left     Time left\n");
    printf("        in Glass 4    in Glass 7\n");

    printf("%3d %9d %12d\n", hs.timeStamp, hs.glass4TimeLeft, hs.glass7TimeLeft);

    for (i = 0; i < stateIdx; i++) {
        if (flipSequence[i] == FLIP4) printf("%15s %12s\n", "flip", "");
        if (flipSequence[i] == FLIP7) printf("%15s %12s\n", "", "flip");
        if (flipSequence[i] == FLIPBOTH) printf("%15s %12s\n", "flip", "flip");

        flip(&hs, flipSequence[i]);
        printf("%3d %9d %12d\n", hs.timeStamp, hs.glass4TimeLeft, hs.glass7TimeLeft);

        runToNextTimestamp(&hs);
        printf("%3d %9d %12d\n", hs.timeStamp, hs.glass4TimeLeft, hs.glass7TimeLeft);
    }
}

void backtracking() {
    int flipAction;

    if (hourglassesStates[stateIdx - 1].timeStamp > target)
        return;

    if (hourglassesStates[stateIdx - 1].timeStamp == target) {
        showSolution(flipSequence);
        exit(0);
    }

    for (flipAction = 0; flipAction < 3; flipAction++) {
        process(flipAction);
        backtracking();
        undo();
    }
}

int main() {
    stateIdx = 0;
    hs.timeStamp = hs.glass4TimeLeft = hs.glass7TimeLeft = 0;
    hourglassesStates[stateIdx] = hs;

    backtracking();

    return 0;
}
