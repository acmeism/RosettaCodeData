import std.stdio;
import std.format;
import std.datetime;
import std.algorithm;

enum months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

void main()
{
  // input	
  string date = "March 7 2009 7:30pm EST";

  // parsing date string to integer values
  string month, md, tz;
  int day, year, hour, minute;
  date.formattedRead("%s %d %d %d:%d%s %s", &month, &day, &year, &hour, &minute, &md, &tz);
  int mon = cast (int) months.countUntil(month) + 1;

  // convert to 24-hour
  if (md == "pm")
    hour += 12;

  // create date from integer
  DateTime dt = DateTime(year, mon, day, hour, minute);

  // output
  writeln(dt);
  writeln(dt + 12.hours);
	
}
