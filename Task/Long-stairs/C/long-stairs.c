#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(void) {
    int trial, secs_tot=0, steps_tot=0;     //keep track of time and steps over all the trials
    int sbeh, slen, wiz, secs;              //all the variables related to an individual trial
    time_t t;
    srand((unsigned) time(&t));             //random number seed
    printf( "Seconds    steps behind    steps ahead\n" );
    for( trial=1;trial<=10000;trial++ ) {   //10000 attempts for the runner
        sbeh = 0; slen = 100; secs = 0;     // initialise this trial
        while(sbeh<slen) {                  //as long as the runner is still on the stairs
            sbeh+=1;                        //runner climbs a step
            for(wiz=1;wiz<=5;wiz++) {       //evil wizard conjures five new steps
                if(rand()%slen < sbeh)
                    sbeh+=1;                //maybe a new step is behind us
                slen+=1;                    //either way, the staircase is longer
            }
            secs+=1;                        //one second has passed
            if(trial==1&&599<secs&&secs<610)
                printf("%d        %d            %d\n", secs, sbeh, slen-sbeh );

        }
        secs_tot+=secs;
        steps_tot+=slen;
    }
    printf( "Average secs taken: %f\n", secs_tot/10000.0 );
    printf( "Average final length of staircase: %f\n", steps_tot/10000.0 );
    return 0;
}
