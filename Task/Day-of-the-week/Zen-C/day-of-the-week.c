import "time.h"

@crepr("struct tm")
struct tm {
    tm_mday : c_int;
    tm_mon  : c_int;
    tm_year : c_int;
}

fn main() {
    let weekday: char[10];
    let t = tm{tm_mday: 25, tm_mon: 11};
    println "Years between 2008 and 2121 when 25th December falls on Sunday:";
    print "[";
    for let year = 2008; year <= 2121; ++year {
        t.tm_year = year - 1900;
        mktime(&t);
        strftime(weekday, 10, "%A", &t);
        if (strcmp(weekday, "Sunday") == 0) { printf("%d, ", year); }
    }
    println "\b\b]";
}
