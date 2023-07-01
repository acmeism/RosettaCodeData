#!/bin/sh
read a; read b;
echo "a+b     = "  `expr $a  +  $b`
echo "a-b     = "  `expr $a  -  $b`
echo "a*b     = "  `expr $a \*  $b`
echo "a/b     = "  `expr $a  /  $b` # truncates towards 0
echo "a mod b = "  `expr $a  %  $b` # same sign as first operand
