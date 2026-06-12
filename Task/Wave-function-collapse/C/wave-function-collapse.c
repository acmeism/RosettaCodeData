#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define XY(row, col, width) ((col)+(row)*(width))
#define XYZ(page, row, col, height, width) XY(XY(page, row, height), col, width)

char blocks[5][3][3]= {
    {
        {0, 0, 0},
        {0, 0, 0},
        {0, 0, 0}
    },{
        {0, 0, 0},
        {1, 1, 1},
        {0, 1, 0}
    },{
        {0, 1, 0},
        {0, 1, 1},
        {0, 1, 0}
    },{
        {0, 1, 0},
        {1, 1, 1},
        {0, 0, 0}
    },{
        {0, 1, 0},
        {1, 1, 0},
        {0, 1, 0}
    }
};

/* avoid problems with slightly negative numbers and C's X%Y */
#define MOD(X,Y) ((Y)+(X))%(Y)

char *wfc(char *blocks, int *bdim /* 5,3,3 */, int *tdim /* 8,8 */) {
    int N= tdim[0]*tdim[1], td0= tdim[0], td1= tdim[1];
    int *adj= calloc(N*4, sizeof (int)); /* indices in R of the four adjacent blocks */
    for (int i= 0; i<td0; i++) {
        for (int j=0; j<td1; j++) {
            adj[XYZ(i,j,0,td1,4)]= XY(MOD(i-1, td0), MOD(j,   td1), td1); /* above (index 1 in a 3x3 grid) */
            adj[XYZ(i,j,1,td1,4)]= XY(MOD(i,   td0), MOD(j-1, td1), td1); /* left  (index 3 in a 3x3 grid) */
            adj[XYZ(i,j,2,td1,4)]= XY(MOD(i,   td0), MOD(j+1, td1), td1); /* right (index 5 in a 3x3 grid) */
            adj[XYZ(i,j,3,td1,4)]= XY(MOD(i+1, td0), MOD(j,   td1), td1); /* below (index 7 in a 3x3 grid) */
        }
    }
    int bd0= bdim[0], bd1= bdim[1], bd2= bdim[2];
    char *horz= malloc(bd0*bd0); /* blocks which can sit next to each other horizontally */
    for (int i= 0; i<bd0; i++) {
        for (int j= 0; j<bd0; j++) {
            horz[XY(i,j,bd0)]= 1;
            for (int k= 0; k<bd1; k++) {
                if (blocks[XYZ(i, k, 0, bd1, bd2)] != blocks[XYZ(j, k, bd2-1, bd1, bd2)]) {
                    horz[XY(i, j, bd0)]= 0;
                }
            }
        }
    }
    char *vert= malloc(bd0*bd0); /* blocks which can sit next to each other vertically */
    for (int i= 0; i<bd0; i++) {
        for (int j= 0; j<bd0; j++) {
            vert[XY(i,j,bd0)]= 1;
            for (int k= 0; k<bd2; k++) {
                if (blocks[XYZ(i, 0, k, bd1, bd2)] != blocks[XYZ(j, bd1-1, k, bd1, bd2)]) {
                    vert[XY(i, j, bd0)]= 0;
                    break;
                }
            }
        }
    }
    char *allow= malloc(4*(bd0+1)*bd0); /* all block constraints, based on neighbors */
    memset(allow, 1, 4*(bd0+1)*bd0);
    for (int i= 0; i<bd0; i++) {
        for (int j= 0; j<bd0; j++) {
            allow[XYZ(0, i, j, bd0+1, bd0)]= vert[XY(j, i, bd0)]; /* above (north) */
            allow[XYZ(1, i, j, bd0+1, bd0)]= horz[XY(j, i, bd0)]; /* left (west) */
            allow[XYZ(2, i, j, bd0+1, bd0)]= horz[XY(i, j, bd0)]; /* right (east) */
            allow[XYZ(3, i, j, bd0+1, bd0)]= vert[XY(i, j, bd0)]; /* below (south) */
        }
    }
    free(horz);
    free(vert);
    int *todo= calloc(N, sizeof (int));
    char *wave= malloc(N*bd0);
    int *entropy= calloc(N, sizeof (int));
    int *indices= calloc(N, sizeof (int));
    int min;
    int *possible= calloc(bd0, sizeof (int));
    int *R= calloc(N, sizeof (int)); /* tile expressed as list of block indices */
    for (int i= 0; i<N; i++) R[i]= bd0;
    while (1) {
        int c= 0;
        for (int i= 0; i<N; i++)
            if (bd0==R[i])
                todo[c++]= i;
        if (!c) break;
        min= bd0;
        for (int i= 0; i<c; i++) {
            entropy[i]= 0;
            for (int j= 0; j<bd0; j++) {
                int K= 4*todo[i];
                entropy[i]+=
                    wave[XY(i, j, bd0)]=
                        allow[XYZ(0, R[adj[XY(todo[i],0,4)]], j, bd0+1, bd0)] &
                        allow[XYZ(1, R[adj[XY(todo[i],1,4)]], j, bd0+1, bd0)] &
                        allow[XYZ(2, R[adj[XY(todo[i],2,4)]], j, bd0+1, bd0)] &
                        allow[XYZ(3, R[adj[XY(todo[i],3,4)]], j, bd0+1, bd0)];
            }
            if (entropy[i] < min) min= entropy[i];
        }
        if (!min) {
            free(R);
            R= NULL;
            break;
        }
        int d= 0;
        for (int i= 0; i<c; i++) {
            if (min==entropy[i]) indices[d++]= i;
        }
        int ndx= indices[random()%d];
        int ind= ndx*bd0;
        d= 0;
        for (int i= 0; i<bd0; i++) {
            if (wave[ind+i]) possible[d++]= i;
        }
        R[todo[ndx]]= possible[random()%d];
    }
    free(adj);
    free(allow);
    free(todo);
    free(wave);
    free(entropy);
    free(indices);
    free(possible);
    if (!R) return NULL;
    char *tile= malloc((1+td0*(bd1-1))*(1+td1*(bd2-1)));
    for (int i0= 0; i0<td0; i0++)
        for (int i1= 0; i1<bd1; i1++)
            for (int j0= 0; j0<td1; j0++)
                for (int j1= 0; j1<bd2; j1++)
                    tile[XY(XY(j0, j1, bd2-1), XY(i0, i1, bd1-1), 1+td1*(bd2-1))]=
                        blocks[XYZ(R[XY(i0, j0, td1)], i1, j1, bd1, bd2)];
    free(R);
    return tile;
}

int main() {
    int bdims[3]= {5,3,3};
    int size[2]= {8,8};
    time_t t;
    srandom((unsigned) time(&t));
    char *tile= wfc((char*)blocks, bdims, size);
    if (!tile) exit(0);
    for (int i= 0; i<17; i++) {
        for (int j= 0; j<17; j++) {
            printf("%c ", " #"[tile[XY(i, j, 17)]]);
        }
        printf("\n");
    }
    free(tile);
    exit(0);
}
