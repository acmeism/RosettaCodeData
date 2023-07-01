#!/usr/local/bin/awk -f
{
   sub("[ \t]*[#;].*$","",$0);
   print;
}
