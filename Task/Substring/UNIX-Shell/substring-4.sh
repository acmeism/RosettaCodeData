#!/bin/sh
str=abcdefghijklmnopqrstuvwxyz
n=12
m=5

printf %s "$str" | cut -c $n-`expr $n + $m - 1`
printf %s "$str" | cut -c $n-
printf '%s\n' "${str%?}"
printf q%s "${str#*q}" | cut -c 1-$m
printf pq%s "${str#*pq}" | cut -c 1-$m
