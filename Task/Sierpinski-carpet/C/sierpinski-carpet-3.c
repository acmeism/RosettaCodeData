#include <stdio.h>
#include <stdlib.h>

typedef struct _PartialGrid{
        char** base;
        int xbegin, xend, ybegin, yend; // yend strictly not used
} PartialGrid;

void sierpinski_hollow(PartialGrid G){
        int len = G.xend - G.xbegin+1;
        int unit = len/3;
        for(int i = G.xbegin+unit; i <G.xbegin+2*unit;i++){
        for(int j = G.ybegin+unit; j <G.ybegin+2*unit;j++){
                G.base[j][i] = ' ';
        }}
}

void sierpinski(PartialGrid G, int iterations){
        if(iterations==0)
                return;
        if((iterations)==1){
                sierpinski_hollow(G);
                sierpinski(G,0);
        }
        sierpinski_hollow(G);
        for(int i=0;i<3;i++){
                for(int j=0;j<3;j++){
                        int length = G.xend-G.xbegin+1;
                        int unit = length/3;
                        PartialGrid q = {G.base, G.xbegin + i*unit, G.xbegin+(i+1)*unit-1,
                                G.ybegin+j*unit, G.ybegin+(j+1)*unit-1};
                        sierpinski(q, iterations-1);
                }
        }
}

int intpow(int base, int expo){
        if(expo==0){
                return 1;
        }
        return base*intpow(base,expo-1);
}

int allocate_grid(char*** g, int n, const char sep){
        int size = intpow(3,n+1);
        *g = (char**)calloc(size, sizeof(char*));
        if(*g==NULL)
                return -1;

        for(int i = 0; i < size; ++i){
                (*g)[i] = (char*)calloc(size, sizeof(char));
                if((*g)[i] == NULL)
                        return -1;
                for(int j = 0; j < size; j++){
                        (*g)[i][j] = sep;
                }
        }

        return size;
}

void print_grid(char** b, int size){
        for(int i = 0; i < size; i++){
                printf("%s\n",b[i]);
        }
}

int main(){
        int n = 3;

        char** basegrid;
        int size = allocate_grid(&basegrid, n, '#');
        if(size == -1)
                return 1; //bad alloc
        PartialGrid b = {basegrid, 0, size-1, 0, size-1};
        sierpinski(b, n);
        print_grid(basegrid, size);
        free(basegrid);

        return 0;
}
