#!/bin/sh
read a; read b;
echo "a+b     = $((a+b))"
echo "a-b     = $((a-b))"
echo "a*b     = $((a*b))"
echo "a/b     = $((a/b))" # truncates towards 0
echo "a mod b = $((a%b))" # same sign as first operand
