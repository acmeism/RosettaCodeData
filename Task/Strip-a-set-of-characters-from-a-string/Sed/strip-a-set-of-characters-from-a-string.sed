#!/bin/bash

strip_char()
{
  echo "$1" | sed "s/[$2]//g"
}
