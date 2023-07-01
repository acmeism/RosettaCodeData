#!/usr/bin/awk -f
BEGIN {
  # Demonstrate how to assign an empty string to a variable.
  a="";
  b="XYZ";
  print "a = ",a;	
  print "b = ",b;	
  print "length(a)=",length(a);
  print "length(b)=",length(b);
  # Demonstrate how to check that a string is empty.
  print "Is a empty ?",length(a)==0;
  print "Is a not empty ?",length(a)!=0;
  # Demonstrate how to check that a string is not empty.
  print "Is b empty ?",length(b)==0;
  print "Is b not empty ?",length(b)!=0;
}
