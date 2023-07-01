#!/usr/bin/python
def repeat(f,n):
  for i in range(n):
    f();

def procedure():
  print("Example");

repeat(procedure,3); #prints "Example" (without quotes) three times, separated by newlines.
