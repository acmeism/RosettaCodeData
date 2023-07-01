#include <cstdlib>   // for rand
#include <algorithm> // for random_shuffle
#include <iostream>  // for output

using namespace std;

class cupboard {
public:
    cupboard() {
        for (int i = 0; i < 100; i++)
            drawers[i] = i;
        random_shuffle(drawers, drawers + 100);
    }

    bool playRandom();
    bool playOptimal();

private:
    int drawers[100];
};

bool cupboard::playRandom() {
    bool openedDrawers[100] = { 0 };
    for (int prisonerNum = 0; prisonerNum < 100; prisonerNum++) { // loops through prisoners numbered 0 through 99
        bool prisonerSuccess = false;
        for (int i = 0; i < 100 / 2; i++) {  // loops through 50 draws for each prisoner
            int drawerNum = rand() % 100;
            if (!openedDrawers[drawerNum]) {
                openedDrawers[drawerNum] = true;
                break;
            }
            if (drawers[drawerNum] == prisonerNum) {
                prisonerSuccess = true;
                break;
            }
        }
        if (!prisonerSuccess)
            return false;
    }
    return true;
}

bool cupboard::playOptimal() {
    for (int prisonerNum = 0; prisonerNum < 100; prisonerNum++) {
        bool prisonerSuccess = false;
        int checkDrawerNum = prisonerNum;
        for (int i = 0; i < 100 / 2; i++) {
            if (drawers[checkDrawerNum] == prisonerNum) {
                prisonerSuccess = true;
                break;
            } else
                checkDrawerNum = drawers[checkDrawerNum];
        }
        if (!prisonerSuccess)
            return false;
    }
    return true;
}

double simulate(char strategy) {
    int numberOfSuccesses = 0;
    for (int i = 0; i < 10000; i++) {
        cupboard d;
        if ((strategy == 'R' && d.playRandom()) || (strategy == 'O' && d.playOptimal())) // will run playRandom or playOptimal but not both because of short-circuit evaluation
            numberOfSuccesses++;
    }

    return numberOfSuccesses * 100.0 / 10000;
}

int main() {
    cout << "Random strategy:  " << simulate('R') << " %" << endl;
    cout << "Optimal strategy: " << simulate('O') << " %" << endl;
    system("PAUSE"); // for Windows
    return 0;
}
