#!/bin/sh
DIR=/tmp/foo
[ `ls -a $DIR|wc -l` -gt 2 ]  && echo $DIR is NOT empty || echo $DIR is empty
