#!/bin/zsh
str='abcdefg'
echo ${str#?}   # Remove first char
echo ${str%?}   # Remove last char
echo ${${str#?}%?}   # Remove first & last chars
