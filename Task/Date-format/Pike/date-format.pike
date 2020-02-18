object cal = Calendar.ISO.Day();
write( cal->format_ymd() +"\n" );
string special = sprintf("%s, %s %d, %d",
                         cal->week_day_name(),
                         cal->month_name(),
                         cal->month_day(),
                         cal->year_no());
write( special +"\n" );
