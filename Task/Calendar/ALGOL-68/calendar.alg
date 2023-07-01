#!/usr/local/bin/a68g --script #

PROC print calendar = (INT year, page width)VOID: (

  []STRING month names = (
      "January","February","March","April","May","June",
      "July","August","September","October","November","December"),
    weekday names = ("Su","Mo","Tu","We","Th","Fr","Sa");
  FORMAT weekday fmt = $g,n(UPB weekday names - LWB weekday names)(" "g)$;

  # Juggle the calendar format to fit the printer/screen width #
  INT day width = UPB weekday names[1], day gap=1;
  INT month width = (day width+day gap) * UPB weekday names-1;
  INT month heading lines = 2;
  INT month lines = (31 OVER UPB weekday names+month heading lines+2); # +2 for head/tail weeks #
  INT year cols = (page width+1) OVER (month width+1);
  INT year rows = (UPB month names-1)OVER year cols + 1;
  INT month gap = (page width - year cols*month width + 1)OVER year cols;
  INT year width = year cols*(month width+month gap)-month gap;
  INT year lines = year rows*month lines;

  MODE MONTHBOX = [month lines, month width]CHAR;
  MODE YEARBOX  = [year  lines, year  width]CHAR;

  INT week start = 1; # Sunday #

  PROC days in month = (INT year, month)INT:
    CASE month IN 31,
      IF year MOD 4 EQ 0 AND year MOD 100 NE 0 OR year MOD 400 EQ 0 THEN 29 ELSE 28 FI,
      31, 30, 31, 30, 31, 31, 30, 31, 30, 31
    ESAC;

  PROC day of week = (INT year, month, day)INT: (
    # Day of the week by Zeller’s Congruence algorithm from 1887 #
    INT y := year, m := month, d := day, c;
    IF m <= 2 THEN m +:= 12; y -:= 1 FI;
    c := y OVER 100;
    y %*:= 100;
    (d - 1 + ((m + 1) * 26) OVER 10 + y + y OVER 4 + c OVER 4 - 2 * c) MOD 7
  );

  MODE SIMPLEOUT = UNION(STRING, []STRING, INT);

  PROC cputf = (REF[]CHAR out, FORMAT fmt, SIMPLEOUT argv)VOID:(
    FILE f; STRING s; associate(f,s);
    putf(f, (fmt, argv));
    out[:UPB s]:=s;
    close(f)
  );

  PROC month repr = (INT year, month)MONTHBOX:(
    MONTHBOX month box; FOR line TO UPB month box DO month box[line,]:=" "* 2 UPB month box OD;
    STRING month name = month names[month];

  # center the title #
    cputf(month box[1,(month width - UPB month name ) OVER 2+1:], $g$, month name);
    cputf(month box[2,], weekday fmt, weekday names);

    INT first day := day of week(year, month, 1);
    FOR day TO days in month(year, month) DO
      INT line = (day+first day-week start) OVER UPB weekday names + month heading lines + 1;
      INT char =((day+first day-week start) MOD UPB weekday names)*(day width+day gap) + 1;
      cputf(month box[line,char:char+day width-1],$g(-day width)$, day)
    OD;
    month box
  );

  PROC year repr = (INT year)YEARBOX:(
    YEARBOX year box;
    FOR line TO UPB year box DO year box[line,]:=" "* 2 UPB year box OD;
    FOR month row FROM 0 TO year rows-1 DO
      FOR month col FROM 0 TO year cols-1 DO
        INT month = month row * year cols + month col + 1;
        IF month > UPB month names THEN
          done
        ELSE
          INT month col width = month width+month gap;
          year box[
            month row*month lines+1 : (month row+1)*month lines,
            month col*month col width+1 : (month col+1)*month col width-month gap
          ] := month repr(year, month)
        FI
      OD
    OD;
    done: year box
  );

  INT center = (year cols*(month width+month gap) - month gap - 1) OVER 2;
  INT indent = (page width - year width) OVER 2;

  printf((
    $n(indent + center - 9)k  g l$, "[Insert Snoopy here]",
    $n(indent + center - 1)k 4d l$, year, $l$,
    $n(indent)k n(year width)(g)  l$, year repr(year)
  ))
);

main: (
CO inspired by http://www.ee.ryerson.ca/~elf/hack/realmen.html
           Real Programmers Don't Use PASCAL - Ed Post
            Datamation, volume 29 number 7, July 1983
              THE REAL PROGRAMMER'S NATURAL HABITAT
"Taped to the wall is a line-printer Snoopy calender for the year 1969."
CO
  INT mankind stepped on the moon = 1969,
      line printer width = 80; # as at 1969! #
  print calendar(mankind stepped on the moon, line printer width)
)
