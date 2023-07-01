/* RosettaCode: Fifteen puzle game, C89, plain vanillia TTY, MVC, § 22 */
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define N 4
#define M 4
enum Move{UP,DOWN,LEFT,RIGHT};int hR;int hC;int cc[N][M];const int nS=100;int
update(enum Move m){const int dx[]={0,0,-1,1};const int dy[]={-1,1,0,0};int i=hR
+dy[m];int j=hC+dx[m];if(i>= 0&&i<N&&j>=0&&j<M){cc[hR][hC]=cc[i][j];cc[i][j]=0;
hR=i;hC=j;return 1;}return 0;}void setup(void){int i,j,k;for(i=0;i<N;i++)for(j=0
;j<M;j++)cc[i][j]=i*M+j+1;cc[N-1][M-1]=0;hR=N-1;hC=M-1;k=0;while(k<nS)k+=update(
(enum Move)(rand()%4));}int isEnd(void){int i,j; int k=1;for(i=0;i<N;i++)for(j=0
;j<M;j++)if((k<N*M)&&(cc[i][j]!=k++))return 0;return 1;}void show(){int i,j;
putchar('\n');for(i=0;i<N;i++)for(j=0;j<M;j++){if(cc[i][j])printf(j!=M-1?" %2d "
:" %2d \n",cc[i][j]);else printf(j!=M-1?" %2s ":" %2s \n", "");}putchar('\n');}
void disp(char* s){printf("\n%s\n", s);}enum Move get(void){int c;for(;;){printf
("%s","enter u/d/l/r : ");c=getchar();while(getchar()!='\n');switch(c){case 27:
exit(0);case'd':return UP;case'u':return DOWN;case'r':return LEFT;case'l':return
RIGHT;}}}void pause(void){getchar();}int main(void){srand((unsigned)time(NULL));
do setup();while(isEnd());show();while(!isEnd()){update(get());show();}disp(
"You win"); pause();return 0;}
