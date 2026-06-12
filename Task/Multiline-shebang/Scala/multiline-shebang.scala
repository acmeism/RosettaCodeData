#!/bin/bash
FOO=bar
scala $0 $@
exit
!#
def fact(n : Int) : Int = {
  var i = n ;
  var a = 1 ;
  while (i > 0) {
    a = a*i ;
    i -= 1 ;
  }
  return a ;
}

println("fact(5) = " + fact(5));
