#!/usr/bin/awk -f
BEGIN {
   x = "She was a soul stripper. She took my heart!";
   print x;
   gsub(/[aei]/,"",x);
   print x;
}
