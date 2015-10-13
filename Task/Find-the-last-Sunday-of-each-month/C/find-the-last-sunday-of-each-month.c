#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define NUM_MONTHS 12

void LastSundays(int year)
{
    time_t t;
    struct tm* datetime;

    int sunday=0;
    int dayOfWeek=0;
    int month=0;
    int monthDay=0;
    int isLeapYear=0;
    int daysInMonth[NUM_MONTHS]={
        31,28,31,30,31,30,31,31,30,31,30,31
    };

    isLeapYear=(year%4==0 || ((year%100==0) && (year%400==0)));

    if(isLeapYear)
    {
        daysInMonth[1]=29;
    }

    time(&t);
    datetime = localtime(&t);
    datetime->tm_year=year-1900;
    for(month=0; month<12;month++)
    {
        datetime->tm_mon=month;
        monthDay=daysInMonth[month];
        datetime->tm_mday=monthDay;

        t = mktime(datetime);
        dayOfWeek=datetime->tm_wday;

        while(dayOfWeek!=sunday)
        {
            monthDay--;
            datetime->tm_mday=monthDay;
            t = mktime(datetime);
            dayOfWeek=datetime->tm_wday;

        }
        printf("%d-%02d-%02d\n",year,month+1,monthDay);
    }

}

int main()
{
    LastSundays(2013);
    return 0;
}
