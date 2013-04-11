#!/usr/bin/awk -f
BEGIN {
  unicodeterm=1   # Assume Unicode support
  if (ENVIRON["LC_ALL"] !~ "UTF") {
    if (ENVIRON["LC_ALL"] != ""
      unicodeterm=0    # LC_ALL is the boss, and it says nay
    else {
      # Check other locale settings if LC_ALL override not set
      if (ENVIRON["LC_CTYPE"] !~ "UTF") {
        if (ENVIRON["LANG"] !~ "UTF")
          unicodeterm=0    # This terminal does not support Unicode
      }
    }
  }

  if (unicodeterm) {
      # This terminal supports Unicode
      # We need a Unicode compatible printf, so we source this externally
      # printf might not know \u or \x, so use octal.
      # U+25B3 => UTF-8 342 226 263
      "/usr/bin/printf \\342\\226\\263\\n"
  } else {
      print "HW65001 This program requires a Unicode compatible terminal"|"cat 1>&2"
    exit 252    # Incompatible hardware
  }
