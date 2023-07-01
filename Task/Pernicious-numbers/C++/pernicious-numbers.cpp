#include <iostream>
using namespace std;

int main() {
    int cnt = 0, cnt2, cnt3, tmp, binary[8];
    for (int i = 3; cnt < 25; i++) {
        tmp = i;
        cnt2 = 0;
        cnt3 = 0;
        for (int j = 7; j > 0; j--) {
            binary[j] = tmp % 2;
            tmp /= 2;
        }
        binary[0] = tmp;
        for (int j = 0; j < 8; j++) {
            if (binary[j] == 1) {
                cnt2++;
            }
        }
        for (int j = 2; j <= (cnt2 / 2); j++) {
            if (cnt2 % j == 0) {
                cnt3++;
                break;
            }
        }
        if (cnt3 == 0 && cnt2 != 1) {
            cout << i << endl;
            cnt++;
        }
    }

    cout << endl;
    int binary2[31];

    for (int i = 888888877; i <= 888888888; i++) {
        tmp = i;
        cnt2 = 0;
        cnt3 = 0;
        for (int j = 30; j > 0; j--) {
            binary2[j] = tmp % 2;
            tmp /= 2;
        }
        binary2[0] = tmp;
        for (int j = 0; j < 31; j++) {
            if (binary2[j] == 1) {
                cnt2++;
            }
        }
        for (int j = 2; j <= (cnt2 / 2); j++) {
            if (cnt2 % j == 0) {
                cnt3++;
                break;
            }
        }
        if (cnt3 == 0 && cnt2 != 1) {
            cout << i << endl;
        }
    }
}
