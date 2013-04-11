#include <stdio.h>
typedef enum{false=0, true=!0} bool;
typedef void iterator;

#include <setjmp.h>
/* declare label otherwise it is not visible in sub-scope */
#define LABEL(label) jmp_buf label; if(setjmp(label))goto label;
#define GOTO(label) longjmp(label, true)

/* the following line is the only time I have ever required "auto" */
#define FOR(i, iterator) { auto bool lambda(i); yield_init = (void *)&lambda; iterator; bool lambda(i)
#define DO {
#define     YIELD(x) if(!yield(x))return
#define     BREAK    return false
#define     CONTINUE return true
#define OD CONTINUE; } }

static volatile void *yield_init; /* not thread safe */
#define YIELDS(type) bool (*yield)(type) = yield_init

iterator fibonacci(int stop){
    YIELDS(int);
    int f[] = {0, 1};
    int i;
    for(i=0; i<stop; i++){
        YIELD(f[i%2]);
        f[i%2]=f[0]+f[1];
    }
}

main(){
  printf("fibonacci: ");
  FOR(int i, fibonacci(16)) DO
    printf("%d, ",i);
  OD;
  printf("...\n");
}
