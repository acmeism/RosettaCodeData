#!/bin/sh

a='1'
b='1'
if [ "$a" -eq "$b" ]; then
  exit 239    # Unexpected error
fi
exit 0    # Program terminated normally
