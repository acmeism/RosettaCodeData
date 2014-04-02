#include <iostream>

int main(){
    const int l = 5;
    const int w = 3;
    int m1[l][w] = {{1,2,3}, {4,5,6}, {7,8,9}, {10,11,12}, {13,14,15}};
    int m2[w][l];

    for(int i=0; i<w; i++){
        for(int x=0; x<l; x++){
            m2[i][x]=m1[x][i];
        }
    }

    // This is just output...

    std::cout << "Before:";
    for(int i=0; i<l; i++){
        std::cout << std::endl;
        for(int x=0; x<w; x++){
            std::cout << m1[i][x] << " ";
        }
    }

    std::cout << "\n\nAfter:";
    for(int i=0; i<w; i++){
        std::cout << std::endl;
        for(int x=0; x<l; x++){
            std::cout << m2[i][x] << " ";
        }
    }

    std::cout << std::endl;

    return 0;
}
