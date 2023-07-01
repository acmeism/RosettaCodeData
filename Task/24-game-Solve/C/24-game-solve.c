#include <stdio.h>

typedef struct {int val, op, left, right;} Node;

Node nodes[10000];
int iNodes;

int b;
float eval(Node x){
    if (x.op != -1){
        float l = eval(nodes[x.left]), r = eval(nodes[x.right]);
        switch(x.op){
            case 0: return l+r;
            case 1: return l-r;
            case 2: return r-l;
            case 3: return l*r;
            case 4: return r?l/r:(b=1,0);
            case 5: return l?r/l:(b=1,0);
        }
    }
    else return x.val*1.;
}

void show(Node x){
    if (x.op != -1){
        printf("(");
        switch(x.op){
            case 0: show(nodes[x.left]); printf(" + "); show(nodes[x.right]); break;
            case 1: show(nodes[x.left]); printf(" - "); show(nodes[x.right]); break;
            case 2: show(nodes[x.right]); printf(" - "); show(nodes[x.left]); break;
            case 3: show(nodes[x.left]); printf(" * "); show(nodes[x.right]); break;
            case 4: show(nodes[x.left]); printf(" / "); show(nodes[x.right]); break;
            case 5: show(nodes[x.right]); printf(" / "); show(nodes[x.left]); break;
        }
        printf(")");
    }
    else printf("%d", x.val);
}

int float_fix(float x){ return x < 0.00001 && x > -0.00001; }

void solutions(int a[], int n, float t, int s){
    if (s == n){
        b = 0;
        float e = eval(nodes[0]);

        if (!b && float_fix(e-t)){
            show(nodes[0]);
            printf("\n");
        }
    }
    else{
        nodes[iNodes++] = (typeof(Node)){a[s],-1,-1,-1};

        for (int op = 0; op < 6; op++){
            int k = iNodes-1;
            for (int i = 0; i < k; i++){
                nodes[iNodes++] = nodes[i];
                nodes[i] = (typeof(Node)){-1,op,iNodes-1,iNodes-2};
                solutions(a, n, t, s+1);
                nodes[i] = nodes[--iNodes];
            }
        }

        iNodes--;
    }
};

int main(){
    // define problem

    int a[4] = {8, 3, 8, 3};
    float t = 24;

    // print all solutions

    nodes[0] = (typeof(Node)){a[0],-1,-1,-1};
    iNodes = 1;

    solutions(a, sizeof(a)/sizeof(int), t, 1);

    return 0;
}
