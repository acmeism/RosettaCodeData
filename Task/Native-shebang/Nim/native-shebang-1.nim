#!/usr/bin/env -S nim c -r --hints:off
import os,strutils
echo commandLineParams().join(" ")
