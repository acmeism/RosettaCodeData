#!/bin/sh
function rot13 () {
   tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
   }

cat ${1+"$@"} | rot13
