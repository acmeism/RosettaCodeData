import os
for directory in ['/', './']:
  open(directory + 'output.txt', 'w').close()  # create /output.txt, then ./output.txt
  os.mkdir(directory + 'docs')                 # create directory /docs, then ./docs
