from algorithm import sorted
from os import walkPattern
from sequtils import toSeq

for path in toSeq(walkPattern("*")).sorted:
  echo path
