#!/bin/sh
read a b || exit
echo `expr "$a" + "$b"`
