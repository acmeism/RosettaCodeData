#!/usr/bin/perl

@ARGV = 'unixdict.txt';
print grep /^[^bc]*a[^c]*b.*c/, <>;
