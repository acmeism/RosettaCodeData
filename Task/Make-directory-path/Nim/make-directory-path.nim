import os

try:
  createDir("./path/to/dir")
  echo "Directory now exists."
except OSError:
  echo "Failed to create the directory."
