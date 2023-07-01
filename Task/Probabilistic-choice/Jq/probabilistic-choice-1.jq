#!/bin/bash

< /dev/urandom tr -cd '0-9' | fold -w 1 | jq -nr -f probabilistic-choice.jq
