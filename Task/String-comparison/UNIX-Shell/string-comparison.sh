#!/bin/sh

A=Bell
B=Ball

# Traditional test command implementations test for equality and inequality
# but do not have a lexical comparison facility
if [ $A = $B ] ; then
  echo 'The strings are equal'
fi
if [ $A != $B ] ; then
  echo 'The strings are not equal'
fi

# All variables in the shell are strings, so numeric content cause no lexical problems
# 0 , -0 , 0.0 and 00 are all lexically different if tested using the above methods.

# However this may not be the case if other tools, such as awk are the slave instead of test.
