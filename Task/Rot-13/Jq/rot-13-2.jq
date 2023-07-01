#!/bin/bash

jq -M -R -r '

def rot13:
  explode
 | map( if 65 <= . and . <= 90 then ((. - 52) % 26) + 65
        elif 97 <= . and . <= 122 then (. - 84) % 26 + 97
        else .
   end)
 | implode;

rot13'
