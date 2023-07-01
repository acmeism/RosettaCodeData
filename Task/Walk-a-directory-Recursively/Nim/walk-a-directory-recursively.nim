import os, re

for file in walkDirRec "/":
  if file.match re".*\.mp3":
    echo file
