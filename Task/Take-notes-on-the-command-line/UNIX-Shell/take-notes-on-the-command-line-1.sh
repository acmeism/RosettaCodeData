#!/usr/bin/env bash

if
  declare NOTES=$HOME/notes.txt
  (($#))
then
  {
    date
    echo -e "\t$*"
  } >> $NOTES
elif [[ -r $NOTES ]]
then more $NOTES
fi
