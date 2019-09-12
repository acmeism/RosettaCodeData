#include <cstdio>
#include <vector>
#include <string>

using namespace std;

void print_vector(const vector<int> &v, size_t n, const vector<string> &s){
        for (size_t i = 0; i < n; ++i)
                printf("%s\t", s[v[i]].c_str());
        printf("\n");
}

void combination_with_repetiton(int sabores, int bolas, const vector<string>& v_sabores){
        sabores--;
        vector<int> v(bolas+1, 0);
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
}

int main(){
        vector<string> options{ "iced", "jam", "plain" };
        combination_with_repetiton(3, 2, options);
        return 0;
}
