#!/bin/bash

read -p "Enter a number of seconds: " WAIT
read -p "Enter an mp3 filename: " FILENAME

sleep $WAIT
ffplay -loglevel quiet -nodisp -autoexit $FILENAME
