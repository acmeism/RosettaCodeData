#include <stdio.h>

int is_vile(int n) {
    int c = 0;
    while ((n&1)==0) {
        n >>= 1;
        c++;
    }
    return c%2==0;
}

void run(int iv,int vile[]) {
    int c,n;
    for(c=0,n=1;c<25;n++){
        if(vile[n]==iv) {
            printf("%d ",n);
            c++;
        }
    }
    printf("\n");
}

void upto(int vile[]) {
    int vc=0,dc=0,n=1,lim;
    for(lim=2;n<=lim;n++) {
        if(vile[n])vc++;else dc++;
        if(n==lim) {
            printf("%4d:   %3d   %3d\n",lim,vc,dc);
            if(lim==1024) break;
            lim *= 2;
        }
    }
}

int main(void) {
    int v[1025];
    for(int i=1;i<=1024;i++) {
        v[i] = is_vile(i);
    }
    run(1,v);
    run(0,v);
    upto(v);
}
