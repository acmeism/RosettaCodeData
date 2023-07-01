#include <stdbool.h>
#include <stdio.h>

char *months[] = {
    "ERR", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
};

struct Date {
    int month, day;
    bool active;
} dates[] = {
    {5,15,true}, {5,16,true}, {5,19,true},
    {6,17,true}, {6,18,true},
    {7,14,true}, {7,16,true},
    {8,14,true}, {8,15,true}, {8,17,true}
};
#define UPPER_BOUND (sizeof(dates) / sizeof(struct Date))

void printRemaining() {
    int i, c;
    for (i = 0, c = 0; i < UPPER_BOUND; i++) {
        if (dates[i].active) {
            c++;
        }
    }
    printf("%d remaining.\n", c);
}

void printAnswer() {
    int i;
    for (i = 0; i < UPPER_BOUND; i++) {
        if (dates[i].active) {
            printf("%s, %d\n", months[dates[i].month], dates[i].day);
        }
    }
}

void firstPass() {
    // the month cannot have a unique day
    int i, j, c;
    for (i = 0; i < UPPER_BOUND; i++) {
        c = 0;

        for (j = 0; j < UPPER_BOUND; j++) {
            if (dates[j].day == dates[i].day) {
                c++;
            }
        }

        if (c == 1) {
            for (j = 0; j < UPPER_BOUND; j++) {
                if (!dates[j].active) continue;
                if (dates[j].month == dates[i].month) {
                    dates[j].active = false;
                }
            }
        }
    }
}

void secondPass() {
    // the day must now be unique
    int i, j, c;
    for (i = 0; i < UPPER_BOUND; i++) {
        if (!dates[i].active) continue;
        c = 0;

        for (j = 0; j < UPPER_BOUND; j++) {
            if (!dates[j].active) continue;
            if (dates[j].day == dates[i].day) {
                c++;
            }
        }

        if (c > 1) {
            for (j = 0; j < UPPER_BOUND; j++) {
                if (!dates[j].active) continue;
                if (dates[j].day == dates[i].day) {
                    dates[j].active = false;
                }
            }
        }
    }
}

void thirdPass() {
    // the month must now be unique
    int i, j, c;
    for (i = 0; i < UPPER_BOUND; i++) {
        if (!dates[i].active) continue;
        c = 0;

        for (j = 0; j < UPPER_BOUND; j++) {
            if (!dates[j].active) continue;
            if (dates[j].month == dates[i].month) {
                c++;
            }
        }

        if (c > 1) {
            for (j = 0; j < UPPER_BOUND; j++) {
                if (!dates[j].active) continue;
                if (dates[j].month == dates[i].month) {
                    dates[j].active = false;
                }
            }
        }
    }
}

int main() {
    printRemaining();
    // the month cannot have a unique day
    firstPass();

    printRemaining();
    // the day must now be unique
    secondPass();

    printRemaining();
    // the month must now be unique
    thirdPass();

    printAnswer();
    return 0;
}
