#!/usr/bin/perl -n -s -i
print unless $. >= $from && $. <= $to;
