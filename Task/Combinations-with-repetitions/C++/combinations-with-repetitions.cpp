#include <stdio.h>
#include <vector>
#include <string>

using namespace std;
vector<string> options{ "iced", "jam", "plain" };

void print_vector(vector<int> v, int n, vector<string> s){
        for (int i = 0; i < n; ++i)
                printf("%s\t", s[v[i]].c_str());
        printf("\n");
}

int combination_with_repetiton(int sabores, int bolas, const vector<string>& v_sabores){
        sabores--;
        vector<int> v;
        for (int i = 0; i <= bolas; ++i)
                v.push_back(0);
        while (true){
                for (int i = 0; i < bolas; ++i){                //vai um
                        if (v[i] > sabores){
                                v[i + 1] += 1;
                                for (int k = i; k >= 0; --k){
                                        v[k] = v[i + 1];
                                }
                                //v[i] = v[i + 1];
                        }
                }

                if (v[bolas] > 0)
                        break;
                print_vector(v, bolas, v_sabores);
                v[0] += 1;
        }

        return 1;
}

int main(){
        combination_with_repetiton(3, 2, options);
        return 0;
}
