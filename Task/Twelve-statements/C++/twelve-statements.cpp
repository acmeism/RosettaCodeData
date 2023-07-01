#include <iostream>
#include <vector>
#include <string>
#include <cmath>

using namespace std;

// convert int (0 or 1) to string (F or T)
inline
string str(int n)
{
    return  n ? "T": "F";
}

int main(void)
{
    int solution_list_number = 1;
    vector<string> st;
    st = {
        " 1. This is a numbered list of twelve statements.",
        " 2. Exactly 3 of the last 6 statements are true.",
        " 3. Exactly 2 of the even-numbered statements are true.",
        " 4. If statement 5 is true, then statements 6 and 7 are both true.",
        " 5. The 3 preceding statements are all false.",
        " 6. Exactly 4 of the odd-numbered statements are true.",
        " 7. Either statement 2 or 3 is true, but not both.",
        " 8. If statement 7 is true, then 5 and 6 are both true.",
        " 9. Exactly 3 of the first 6 statements are true.",
        " 10. The next two statements are both true.",
        " 11. Exactly 1 of statements 7, 8 and 9 are true.",
        " 12. Exactly 4 of the preceding statements are true."
    };  //  Good solution is: 1 3 4 6 7 11 are true

    int n = 12; // Number of statements.
    int nTemp = (int)pow(2, n); // Number of solutions to check.
    for (int counter = 0; counter < nTemp; counter++)
    {
        vector<int> s;
        for (int k = 0; k < n; k++)
        {
            s.push_back((counter >> k) & 0x1);
        }
        vector<int> test(12);
        int sum = 0;
        // check each of the nTemp solutions for match.
        // 1. This is a numbered list of twelve statements.
        test[0] = s[0];

        // 2. Exactly 3 of the last 6 statements are true.
        sum = s[6]+ s[7]+s[8]+s[9]+s[10]+s[11];
        test[1] = ((sum == 3) == s[1]);

        // 3. Exactly 2 of the even-numbered statements are true.
        sum = s[1]+s[3]+s[5]+s[7]+s[9]+s[11];
        test[2] = ((sum == 2) == s[2]);

        // 4. If statement 5 is true, then statements 6 and 7 are both true.
        test[3] = ((s[4] ? (s[5] && s[6]) : true) == s[3]);

        // 5. The 3 preceding statements are all false.
        test[4] = (((s[1] + s[2] + s[3]) == 0) == s[4]);

        // 6. Exactly 4 of the odd-numbered statements are true.
        sum = s[0] + s[2] + s[4] + s[6] + s[8] + s[10];
        test[5] = ((sum == 4) == s[5]);

        // 7. Either statement 2 or 3 is true, but not both.
        test[6] = (((s[1] + s[2]) == 1) == s[6]);

        // 8. If statement 7 is true, then 5 and 6 are both true.
        test[7] = ((s[6] ? (s[4] && s[5]) : true) == s[7]);

        // 9. Exactly 3 of the first 6 statements are true.
        sum = s[0]+s[1]+s[2]+s[3]+s[4]+s[5];
        test[8] = ((sum == 3) == s[8]);

        // 10. The next two statements are both true.
        test[9] = ((s[10] && s[11]) == s[9]);

        // 11. Exactly 1 of statements 7, 8 and 9 are true.
        sum = s[6]+ s[7] + s[8];
        test[10] = ((sum == 1) == s[10]);

        // 12. Exactly 4 of the preceding statements are true.
        sum = s[0]+s[1]+s[2]+s[3]+s[4]+s[5]+s[6]+s[7]+s[8]+s[9]+s[10];
        test[11] = ((sum == 4) == s[11]);

        // Check test results and print solution if 11 or 12 are true
        int resultsTrue = 0;
        for(unsigned int i = 0; i < test.size(); i++){
            resultsTrue += test[i];
        }
        if(resultsTrue == 11 || resultsTrue == 12){
            cout << solution_list_number++ << ". " ;
            string output = "1:"+str(s[0])+"  2:"+str(s[1])+"  3:"+str(s[2])
                        +"  4:"+str(s[3])+"  5:"+str(s[4])+"  6:"+ str(s[5])
                        +"  7:"+str(s[6])+"  8:"+str(s[7])+"  9:"+str(s[8])
                        +"  10:"+str(s[9])+"  11:"+str(s[10])+"  12:"+ str(s[11]);

            if (resultsTrue == 12) {
                cout << "Full Match, good solution!" << endl;
                cout << "\t" << output << endl;
            }
            else if(resultsTrue == 11){
                int i;
                for(i = 0; i < 12; i++){
                    if(test[i] == 0){
                        break;
                    }
                }
                cout << "Missed by one statement: " << st[i] << endl;
                cout << "\t" << output << endl;
            }
        }
    }
}
