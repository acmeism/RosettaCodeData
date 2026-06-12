# 20211215 Perl programming solution

use strict;
use warnings;

BEGIN {
   package MultitonDemo ;
   use Moo;
   with 'Role::Multiton';
   has [qw(attribute)] => ( is => 'rw');
   $INC{"MultitonDemo.pm"} = 1;
}

use MultitonDemo;

print "We create several instances and compare them to see if multiton is in effect.\n";
print "\n";
print "Instance   Constructor  Attribute\n";
print "\n";
print "0            multiton       0\n";
print "1            multiton       1\n";
print "2            multiton       0\n";
print "3              new          0\n";
print "4              new          0\n";

my $inst0 = MultitonDemo->multiton (attribute => 0);
my $inst1 = MultitonDemo->multiton (attribute => 1);
my $inst2 = MultitonDemo->multiton (attribute => 0);
my $inst3 = MultitonDemo->new      (attribute => 0);
my $inst4 = MultitonDemo->new      (attribute => 0);

print "\n";
if ($inst0 eq $inst1) { print "Instance0 and Instance1 share the same object\n" };
if ($inst1 eq $inst2) { print "Instance1 and Instance2 share the same object\n" };
if ($inst0 eq $inst2) { print "Instance0 and Instance2 share the same object\n" };
if ($inst0 eq $inst3) { print "Instance0 and Instance3 share the same object\n" };
if ($inst3 eq $inst4) { print "Instance3 and Instance4 share the same object\n" };
