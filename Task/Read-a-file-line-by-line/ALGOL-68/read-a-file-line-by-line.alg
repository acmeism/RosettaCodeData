#!/usr/local/bin/a68g --script #

FILE foobar;
INT errno = open(foobar, "Read_a_file_line_by_line.a68", stand in channel);

STRING line;
FORMAT line fmt = $gl$;

PROC mount next tape = (REF FILE file)BOOL: (
  print("Please mount next tape or q to quit");
  IF read char = "q" THEN done ELSE TRUE FI
);

on physical file end(foobar, mount next tape);
on logical file end(foobar, (REF FILE skip)BOOL: done);

FOR count DO
  getf(foobar, (line fmt, line));
  printf(($g(0)": "$, count, line fmt, line))
OD;
done: SKIP
