#include <inttypes.h> /* requires c99 */
#include <stdbool.h>  /* requires c99 */
#include <stdio.h>
#include <stdlib.h>

#define N_EL 5

uintmax_t sec_to_week(uintmax_t);
uintmax_t sec_to_day(uintmax_t);
uintmax_t sec_to_hour(uintmax_t);
uintmax_t sec_to_min(uintmax_t);

uintmax_t week_to_sec(uintmax_t);
uintmax_t day_to_sec(uintmax_t);
uintmax_t hour_to_sec(uintmax_t);
uintmax_t min_to_sec(uintmax_t);

char *format_sec(uintmax_t);
    /* the primary function */


int main(int argc, char *argv[])
{
    uintmax_t input;
    char *a;

    if(argc<2) {
        printf("usage: %s #seconds\n", argv[0]);
        return 1;
    }
    input = strtoumax(argv[1],(void *)0, 10 /*base 10*/);
    if(input<1) {
        printf("Bad input: %s\n", argv[1]);
        printf("usage: %s #seconds\n", argv[0]);
        return 1;
    }
    printf("Number entered: %" PRIuMAX "\n", input);
    a = format_sec(input);
    printf(a);
    free(a);

    return 0;
}

/* note: must free memory
 * after using this function */
char *format_sec(uintmax_t input)
{
    int i;
    bool first;
    uintmax_t weeks, days, hours, mins;
    /*seconds kept in input*/

    char *retval;
    FILE *stream;
    size_t size;
    uintmax_t *traverse[N_EL]={&weeks,&days,
            &hours,&mins,&input};
    char *labels[N_EL]={"wk","d","hr","min","sec"};

    weeks = sec_to_week(input);
    input = input - week_to_sec(weeks);

    days = sec_to_day(input);
    input = input - day_to_sec(days);

    hours = sec_to_hour(input);
    input = input - hour_to_sec(hours);

    mins = sec_to_min(input);
    input = input - min_to_sec(mins);
    /* input now has the remaining seconds */

    /* open stream */
    stream = open_memstream(&retval,&size);
    if(stream == 0) {
        fprintf(stderr,"Unable to allocate memory");
        return 0;
    }

    /* populate stream */
    first = true;
    for(i=0;i<N_EL;i++) {
        if ( *(traverse[i]) != 0 ) {
            if(!first) {
                fprintf(stream,", %" PRIuMAX " %s",
                        *(traverse[i]), labels[i]);
            } else {
                fprintf(stream,"%" PRIuMAX " %s",
                        *(traverse[i]), labels[i]);
            }
            fflush(stream);
            first=false;
        }
    }
    fprintf(stream,"\n");
    fclose(stream);
    return retval;

}

uintmax_t sec_to_week(uintmax_t seconds)
{
    return sec_to_day(seconds)/7;
}

uintmax_t sec_to_day(uintmax_t seconds)
{
    return sec_to_hour(seconds)/24;
}

uintmax_t sec_to_hour(uintmax_t seconds)
{
    return sec_to_min(seconds)/60;
}

uintmax_t sec_to_min(uintmax_t seconds)
{
    return seconds/60;
}

uintmax_t week_to_sec(uintmax_t weeks)
{
    return day_to_sec(weeks*7);
}

uintmax_t day_to_sec(uintmax_t days)
{
    return hour_to_sec(days*24);
}

uintmax_t hour_to_sec(uintmax_t hours)
{
    return min_to_sec(hours*60);
}

uintmax_t min_to_sec(uintmax_t minutes)
{
    return minutes*60;
}
