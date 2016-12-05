import os, strutils

if "utf" in getEnv("LANG").toLower:
  echo "Unicode is supported on this terminal and U+25B3 is: △"
else:
  echo "Unicode is not supported on this terminal."
