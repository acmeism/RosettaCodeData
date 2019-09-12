#!/usr/bin/env perl6

# Reference:
# https://docs.perl6.org/language/classtut
# https://github.com/teodozjan/perl-store

use v6;
use PerlStore::FileStore;

class Point {
    has Int $.x;
    has Int $.y;
}

class Rectangle does  FileStore {
    has Point $.lower;
    has Point $.upper;

    method area() returns Int {
        ($!upper.x - $!lower.x) * ( $!upper.y - $!lower.y);
    }
}

my $r1 = Rectangle.new(lower => Point.new(x => 0, y => 0),
                      upper => Point.new(x => 10, y => 10));
say "Create Rectangle1 with area ",$r1.area();
say "Serialize Rectangle1 to object.dat";
$r1.to_file('./objects.dat');
say "";
say "take a peek on object.dat ..";
say slurp "./objects.dat";
say "";
say "Deserialize to Rectangle2";
my $r2 = from_file('objects.dat');
say "Rectangle2 is of type ", $r2.WHAT;
say "Rectangle2 area is ", $r2.area();
